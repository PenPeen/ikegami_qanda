# 回答コントローラー
class AnswersController < ApplicationController
  #回答削除=>管理者のみ
  before_action :permit_delete, only: [:destroy] 
  #回答作成=>ログインユーザーのみ
  before_action :permit_login_user, only: [:create] 

  # 検証エラー後に画面更新をした際のエラー回避
  def index
    redirect_to question_path(params[:question_id])
  end
  
  # 保存
  def create
    
    @answer = Answer.new(answer_params)
    @answer.question_id = params[:question_id] # foreign key
    @question = Question.find(params[:question_id])
    
    # 検証
    if @answer.save
      redirect_to question_path(@question)
    
    #検証失敗
    else
      flash.now[:alert] = 'コメントが未入力です。'
      @answers = Answer.where(question_id: @question.id) # 質問に対応する回答取得
      render 'questions/show', status: :unprocessable_entity #Status 422
    end
  end
  
  # 削除
  def destroy
    
    @answer = Answer.find(params[:id])
    @answer.destroy
    
    @question = Question.find(params[:question_id])
    # 303リダイレクト ※Turbo使用時のリダイレクト先リソース削除防止
    redirect_to question_path(@question), status: :see_other
  end
  
  # ********** private methods ********** 
  private
    def answer_params
      params.require(:answer).permit(:name,:content)
    end
    
    # アクセス権設定
    # 管理者のみ
    def permit_delete
      if user_signed_in? && current_user.admin? 
      else
        # 303リダイレクト
        blocking_access_delete 
      end
    end
    
    # 管理者＋一般ユーザのみ
    def permit_login_user
      if user_signed_in? == false
        blocking_access
      end
    end
    
    # アクセス禁止 アクション実行時 
    # flashメッセージを表示し、質問一覧へリダイレクト
    def blocking_access
      flash[:alert] = "あなたの権限では行えない操作です！"
      redirect_to questions_index_path
    end
    
    # アクセス禁止 アクション実行時(HTTP:DELETE)
    
    # リダイレクト先のリソース削除しないよう（Turbo使用時）
    # flashメッセージを表示し、質問一覧へリダイレクト ※303リダイレクト
    def blocking_access_delete
      flash[:alert] = "あなたの権限では行えない操作です！"
      redirect_to questions_index_path, status: :see_other
    end
   
end
