class CommentsController < ApplicationController
def create
  
  @film = Film.find(params[:film_id])

  @comment = @film.comments.build(comment_params)
  
  if user_signed_in?
    @comment.user = current_user
    @comment.author_name = current_user.email 
  end

  if @comment.save
    redirect_to film_path(@film), notice: 'Comentário enviado com sucesso!'
  else
    
    redirect_to film_path(@film), alert: 'Erro ao enviar comentário.'
  end
end

private

def comment_params
  params.require(:comment).permit(:content, :author_name)
end
end
