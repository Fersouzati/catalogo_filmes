# Catálogo de Filmes - Desafio Técnico Mainô 🎬

## Visão Geral

Este projeto é uma aplicação web desenvolvida em Ruby on Rails como parte do desafio técnico da Mainô. O objetivo é criar um catálogo de filmes interativo, permitindo que usuários visualizem filmes, adicionem comentários e, se autenticados, gerenciem (cadastrem, editem, apaguem) seus próprios filmes. A aplicação inclui funcionalidades como autenticação, paginação, busca, filtros, categorias, tags, upload de imagens e um sistema de importação em massa via CSV processado em segundo plano.

O foco principal foi na **qualidade do código**, **boas práticas de desenvolvimento Rails**, **aderência aos requisitos** e **implementação robusta das funcionalidades**, incluindo testes automatizados e um super diferencial.

## Funcionalidades Implementadas

A aplicação implementa **todas** as funcionalidades obrigatórias, **todos** os opcionais abordados (com exceção do Diferencial 2 - IA) e o **Super Diferencial 1**.

### ✅ Funcionalidades Obrigatórias

* **Autenticação Completa (Devise):**
    * Cadastro de novos usuários.
    * Login e Logout seguros.
    * Recuperação de senha.
    * Edição de perfil e alteração de senha pelo usuário.
* **Gerenciamento de Filmes (CRUD):**
    * Usuários autenticados podem cadastrar novos filmes.
    * Usuários podem editar e apagar **apenas** os filmes que eles criaram (lógica de autorização implementada no Controller).
    * Associação clara entre `Filme` e `User` (criador).
* **Área Pública:**
    * Listagem de todos os filmes cadastrados, ordenada do **mais novo para o mais antigo**.
    * **Paginação** eficiente utilizando a gem `Kaminari` (6 filmes por página).
    * Visualização dos detalhes de um filme (título, sinopse, ano, duração, diretor, poster, categorias, tags).
* **Sistema de Comentários:**
    * Permite comentários **anônimos** (solicitando apenas nome e conteúdo).
    * Permite comentários de **usuários logados** (vinculando automaticamente o usuário e usando seu e-mail como `author_name`).
    * Comentários são exibidos na página do filme, ordenados do **mais recente para o mais antigo**.
    * Implementada validação para garantir que o conteúdo do comentário não esteja vazio.
    * Corrigida restrição de chave estrangeira (`dependent: :destroy`) para permitir a exclusão de filmes com comentários.

### ✨ Funcionalidades Opcionais (Concluídas)

* **Categorias:**
    * Implementada relação **Muitos-para-Muitos** entre Filmes e Categorias usando uma tabela de junção (`FilmCategory`) e associações `has_many :through`.
    * CRUD administrativo completo para Categorias (criado via `scaffold`) permite cadastrar/gerenciar categorias (ex: Ação, Comédia).
    * Formulário de Filme permite selecionar múltiplas categorias através de checkboxes.
    * Categorias associadas são exibidas na página de detalhes do filme.
* **Busca e Filtros:**
    * Formulário de busca na página inicial permite buscar filmes por:
        * **Título** (busca parcial, case-insensitive - `ILIKE`).
        * **Diretor** (busca parcial, case-insensitive - `ILIKE`).
        * **Ano de Lançamento** (busca exata).
        * **Categoria** (usando um dropdown populado com as categorias existentes).
        * **Tags** (busca por filmes que contenham *qualquer* das tags listadas, separadas por vírgula).
* **Tags:**
    * Implementada relação **Muitos-para-Muitos** manual entre Filmes e Tags (similar às Categorias) usando `FilmTag` e `has_many :through`.
    * Formulário de Filme permite adicionar múltiplas tags através de um campo de texto (tags separadas por vírgula).
    * Novas tags são **criadas automaticamente** se não existirem no banco de dados (`find_or_create_by`).
    * Tags associadas são exibidas na página de detalhes do filme.
* **Upload de Poster (Active Storage):**
    * Utilizado o **Active Storage** do Rails para permitir o upload de uma imagem (poster) para cada filme.
    * O poster é exibido na página de detalhes do filme e na listagem (com CSS para controlar o tamanho).
* **Internacionalização (I18n):**
    * Aplicação configurada para **Português do Brasil (`pt-BR`)** como idioma padrão.
    * Utilizada a gem `rails-i18n` para traduções padrão do Rails (datas, horas, mensagens de erro de validação).
    * Criado arquivo `config/locales/pt-BR.yml` para traduzir todos os modelos (`Film`, `Category`, `Comment`, `User`), atributos e textos da interface (títulos, botões, links, placeholders) usando o helper `t()`.
    * Interface do **Devise** traduzida utilizando o arquivo específico `config/locales/devise.pt-BR.yml` correto para a versão do Devise, garantindo a tradução automática.
* **Testes Automatizados (RSpec):**
    * Configurada a suíte de testes com **RSpec**, **FactoryBot** (para criação de dados de teste), **Capybara** (para testes de sistema/feature) e **DatabaseCleaner**.
    * Inclui testes básicos para:
        * **Models:** Validações e associações (`film_spec.rb`, `comment_spec.rb`).
        * **Controllers:** Ações CRUD principais (`films_controller_spec.rb`).
        * **System:** Simulação de um fluxo de usuário completo (login, criação de filme, adição de comentário) usando Capybara (`user_creates_film_and_comments_spec.rb`).

### 🚀 Super Diferencial 1: Importação em Massa via CSV

* **Funcionalidade:** Usuários autenticados possuem acesso a uma seção para importar múltiplos filmes de uma só vez através do upload de um arquivo `.csv`.
* **Processamento Assíncrono (Sidekiq):** A leitura do CSV e a criação dos filmes são delegadas a um Job (`ImportMoviesJob`) que é processado em segundo plano pelo **Sidekiq**, utilizando **Redis** como backend. Isso evita que a interface do usuário fique bloqueada durante importações longas.
* **Acompanhamento de Status:** Um modelo `ImportStatus` rastreia o progresso de cada importação (Pendente, Processando, Concluído, Erro). O usuário é redirecionado para uma página que exibe o status atual.
* **Notificação por E-mail (ActionMailer):** Ao final do processamento (sucesso ou falha), o usuário que iniciou a importação recebe um **e-mail detalhado** contendo um resumo:
    * Número de filmes importados com sucesso.
    * Número de filmes que falharam na importação.
    * Lista detalhada dos erros de validação para cada filme que falhou.
* **Robustez:** O Job inclui tratamento de erros (CSV mal formatado, falhas ao salvar filmes), logging detalhado e garante a exclusão do arquivo CSV temporário após o processamento. A interface previne submissões múltiplas do formulário usando Turbo.
* **Configuração de E-mail:**
    * **Desenvolvimento:** Configurado para usar **SMTP do Gmail** (requer configuração de credenciais via `rails credentials:edit` - ver seção "Como Rodar Localmente"). Alternativamente, pode-se usar `letter_opener`.
    * **Produção:** Preparado para usar um serviço de e-mail transacional via variáveis de ambiente.

## Tecnologias Utilizadas

* **Backend:**  Ruby on Rails (versão 8.1.0)
* **Banco de Dados:** PostgreSQL
* **Autenticação:** Devise
* **Paginação:** Kaminari
* **Upload de Arquivos:** Active Storage (Rails nativo)
* **Processamento em Segundo Plano:** Sidekiq, Redis
* **Envio de E-mail:** ActionMailer (Rails nativo)
* **Testes:** RSpec, FactoryBot, Capybara, Selenium WebDriver, DatabaseCleaner
* **Internacionalização:** Rails I18n, rails-i18n, devise-i18n
* **Frontend:** HTML, CSS (com alguns estilos inline e externos), JavaScript (com Stimulus via Importmap)

## Como Rodar o Projeto Localmente

Siga os passos abaixo para configurar e rodar a aplicação no seu ambiente de desenvolvimento:

1.  **Pré-requisitos:**
    * Ruby (versão 8.1.0 )
    * Bundler (`gem install bundler`)
    * Node.js e Yarn (necessários para o pipeline de assets do Rails)
    * PostgreSQL (servidor rodando)
    * Redis (servidor rodando - essencial para Sidekiq)
2.  **Clone o repositório:**
    ```bash
    git clone https://github.com/Fersouzati/catalogo_filmes.git
    cd catalogo_filmes
    ```
3.  **Instale as dependências:**
    ```bash
    bundle install
    yarn install # Instala dependências JavaScript
    ```
4.  **Configure o banco de dados:**
    * Certifique-se de que seu servidor PostgreSQL está rodando.
    * Se necessário, copie `config/database.yml.example` para `config/database.yml` e edite com seu usuário e senha do Postgres.
    * Crie os bancos de dados de desenvolvimento e teste:
        ```bash
        rails db:create
        ```
    * Execute as migrações para criar todas as tabelas:
        ```bash
        rails db:migrate
        ```
5.  **Configure as Credenciais do Gmail (Para Teste de E-mail do Diferencial 1):**
    * Gere uma "Senha de App" para sua conta Google (se usar verificação em duas etapas) ou habilite "Acesso a app menos seguro" (não recomendado).
    * Edite as credenciais seguras do Rails:
        ```powershell
        # No PowerShell (Windows):
        $env:EDITOR='code --wait'; rails credentials:edit
        ```
        ```bash
        # No Bash/Zsh (Linux/Mac/WSL):
        EDITOR="code --wait" rails credentials:edit
        ```
    * Dentro do editor que abrir, adicione (ou confirme) a chave `gmail:`:
        ```yaml
        gmail:
          address: seu_email@gmail.com
          password: SUA_SENHA_DE_APP_AQUI_OU_SENHA_NORMAL
        ```
    * Salve e feche o editor.
6.  **Inicie os Servidores (em 3 terminais separados):**
    * **Terminal 1 (Redis):** Certifique-se de que o Redis está rodando. O comando pode variar dependendo da sua instalação (ex: `redis-server` ou `sudo service redis-server start` no WSL/Linux).
    * **Terminal 2 (Sidekiq):** Navegue até a pasta do projeto (`cd catalogo_filmes`) e inicie o Sidekiq:
        ```bash
        bundle exec sidekiq
        ```
    * **Terminal 3 (Rails Server):** Navegue até a pasta do projeto (`cd catalogo_filmes`) e inicie o servidor Rails:
        ```bash
        rails server
        ```
7.  **Acesse a aplicação:** Abra seu navegador web e visite `http://localhost:3000`.

## Formato Esperado do CSV para Importação em Massa

Para usar a funcionalidade de importação em massa (Super Diferencial 1), o arquivo CSV deve seguir o seguinte formato:

* **Encoding:** UTF-8 recomendado.
* **Separador:** Vírgula (`,`).
* **Cabeçalho (Obrigatório na primeira linha):** `title,synopsis,release_year,duration,director`
* **Colunas:**
    * `title`: Título do filme (obrigatório, mínimo 2 caracteres).
    * `synopsis`: Sinopse do filme (obrigatório, mínimo 10 caracteres).
    * `release_year`: Ano de lançamento (número inteiro obrigatório, entre 1801 e o ano atual).
    * `duration`: Duração em minutos (número inteiro obrigatório, maior que 0).
    * `director`: Nome do diretor (obrigatório, mínimo 2 caracteres).

**Exemplo de Conteúdo Válido:**

```csv
title,synopsis,release_year,duration,director
"O Poderoso Chefão","Um patriarca envelhecido da máfia transfere o controle de seu império criminoso para seu filho relutante.",1972,175,"Francis Ford Coppola"
Interestelar,"Um grupo de exploradores viaja através de um buraco de minhoca no espaço na tentativa de garantir a sobrevivência da humanidade.",2014,169,"Christopher Nolan"
"Cidade de Deus","A história de dois meninos crescendo em um bairro violento do Rio de Janeiro, contada ao longo de várias décadas.",2002,130,"Fernando Meirelles"
(Use aspas duplas " ao redor dos campos title ou synopsis se eles contiverem vírgulas).

Executando os Testes (RSpec)
Para rodar a suíte de testes automatizados:

Prepare o banco de dados de teste:
rails db:test:prepare
Execute os testes:
bundle exec rspec

Deploy

A aplicação está hospedada na plataforma Render 

Link da Aplicação: https://catalogo-filmes-808l.onrender.com
Observação: Conforme especificado no desafio, o deploy do Sidekiq (e, portanto, a funcionalidade de importação CSV em produção) não é obrigatório devido à necessidade de um plano pago para o serviço Redis no Render. A funcionalidade foi completamente implementada e testada em ambiente de desenvolvimento.

Autor
Nanda -

