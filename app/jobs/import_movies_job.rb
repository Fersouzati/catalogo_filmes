require 'csv' # Garante que a biblioteca CSV está carregada

class ImportMoviesJob
  include Sidekiq::Job
  sidekiq_options retry: 1 # Tenta rodar de novo só 1 vez em caso de falha inesperada

  def perform(file_path, user_id, import_status_id)
    import_status = ImportStatus.find_by(id: import_status_id) # Usa find_by para evitar erro se ID não existir

    # ▼▼ PROTEÇÃO 1: Verifica o Status Antes de Começar ▼▼
    unless import_status && import_status.status == "pending"
      Rails.logger.warn("ImportMoviesJob: ImportStatus #{import_status_id} não está pendente ou não foi encontrado. Abortando job.")
      # Opcional: Apagar o arquivo aqui também se ele não for mais necessário
      # File.delete(file_path) if file_path.present? && File.exist?(file_path)
      return # Sai do job sem fazer nada
    end

    # Marca como em processamento
    import_status.update!(status: "processing") # Use update! para gerar erro se falhar
    user = User.find(user_id)

    begin
      CSV.foreach(file_path, headers: true, encoding: 'UTF-8') do |row| # Adicionado encoding UTF-8 por segurança
        # Considerar usar find_or_create_by para evitar duplicatas exatas,
        # mas para CSVs grandes isso pode ser lento. A proteção de status é mais importante aqui.
        film = user.films.build( # Usar 'build' em vez de 'create' pode ser mais seguro dentro de loops
          title: row["title"],
          synopsis: row["synopsis"],
          release_year: row["release_year"].to_i,
          duration: row["duration"].to_i,
          director: row["director"]
        )
        unless film.save # Tenta salvar e loga erro se falhar
          Rails.logger.error("ImportMoviesJob: Erro ao salvar filme: #{film.errors.full_messages.join(', ')} - Linha CSV: #{row.to_hash}")
          # Poderia adicionar lógica aqui para registrar quais linhas falharam
        end
      end

      import_status.update!(status: "finished")
      UserMailer.import_finished(user).deliver_now
      Rails.logger.info("ImportMoviesJob: Importação #{import_status_id} concluída com sucesso.")

    rescue CSV::MalformedCSVError => e
      Rails.logger.error("ImportMoviesJob: Erro de CSV mal formatado para importação #{import_status_id}: #{e.message}")
      import_status.update!(status: "error", error_message: "CSV mal formatado: #{e.message}")
    rescue => e # Captura outros erros
      Rails.logger.error("ImportMoviesJob: Erro inesperado na importação #{import_status_id}: #{e.message} \n Backtrace: #{e.backtrace.join("\n")}")
      import_status.update!(status: "error", error_message: "Erro inesperado: #{e.message}")
    ensure
      # ▼▼ PROTEÇÃO 2: Apaga o Arquivo Temporário SEMPRE ▼▼
      # Garante que o arquivo seja apagado mesmo se houver erro
      if file_path.present? && File.exist?(file_path)
        begin
          File.delete(file_path)
          Rails.logger.info("ImportMoviesJob: Arquivo temporário #{file_path} apagado.")
        rescue => e
          Rails.logger.error("ImportMoviesJob: Falha ao apagar arquivo temporário #{file_path}: #{e.message}")
        end
      end
    end
  end
end