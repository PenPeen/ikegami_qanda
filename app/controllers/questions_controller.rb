# 質問コントローラー
class QuestionsController < ApplicationController
  
  #質問更新 => 管理者のみ許可
  before_action :permit_admin, only: [:edit,:update]
  #質問作成... => ログインユーザのみ許可
  before_action :permit_login_user, only: [:new,:create,:my_question]
  #質問ステータス変更 => 管理者+自身が作成した質問のみ許可
  before_action :permit_update, only: [:update_resolve], if: proc{!current_user.admin?}
  #質問の削除 => 管理者+自身が作成した質問のみ許可
  before_action :permit_delete, only: [:destroy], if: proc{!current_user.admin?} 
  
  # 一覧表示
  def index
    # 質問取得 -kaminari
    @questions = Question.page(params[:page]).per(5).order(created_at: 'DESC') 
  end
  
  # 新規作成
  def new
    @mode = 'new'
    @question = Question.new
  end
  
  # 登録
  def create
    @question = Question.new(question_params) #ストロングパラメータ
    @question.user_id = current_user.id #foreign Key
    
    # 検証
    if @question.save
      redirect_to questions_index_path
    else
      render 'new', status: :unprocessable_entity #422エラー
    end
  end
  
  # 詳細
  def show
    @question = Question.find(params[:id]) #質問取得
    @answer = Answer.new
    @answers = Answer.where(question_id: @question.id) # 質問に対応するコメント取得
  end
  
  # 編集
  def edit
    @mode = 'edit'
    @question = Question.find(params[:id]) #質問取得
  end
  
  # 更新
  def update
    @question = Question.find(params[:id]) #質問取得
    @question.user_id = current_user.id #foreign Key
    
    # 検証
    if @question.update(question_params)
      redirect_to question_path(@question)
    else
      render 'edit', status: :unprocessable_entity
    end
  end
  
  #削除
  def destroy
    @question = Question.find(params[:id]) #質問取得

    @question.destroy
    flash[:notice] = "質問の削除が完了しました。"
    redirect_to questions_index_path, status: :see_other #303リダイレクト
  end
  
  # *** 独自で定義したアクション***
  
  # あなたの質問
  def my_question
    @questions = Question.page(params[:page]).per(5)
    .where(user_id: current_user.id)
    .order(created_at: 'DESC') 
    
    render 'index'
  end
  
  # ステータス ：回答待ち 表示
  def unanswered
    @questions = Question.page(params[:page]).per(5)
    .where(progress: '回答待ち')
    .order(created_at: 'DESC') 
    
    render 'index'
  end
  
  # ステータス ：解決済み 表示
  def resolve
    @questions = Question.page(params[:page]).per(5)
    .where(progress: '解決済み')
    .order(created_at: 'DESC') 
    
    render 'index'
  end
  
  # ステータスを解決済みへ
  def update_resolve 
    @question = Question.find(params[:id])
    @question.progress = '解決済み'
    @question.save
    
    flash[:notice] = "質問が解決済みへと変更されました！"
    redirect_to questions_path(@question), status: 303
  end
  
  # 質問検索
  def search
    @questions =
      Question.where("title like? OR content like?", "%#{params[:search]}%", "%#{params[:search]}%")
    
    # 検索結果
    if @questions.exists? == false
      flash.now[:warning]='検索結果がありませんでした。' 
    else
      flash.now[:notice]='検索が完了しました！'
    end
    
    @questions = @questions.page(params[:page]) # kaminari対応
    
    render "index"
  end
  
  # ********** private methods ********** 
  private 
    
    # ストロングパラメータ取得
    def question_params
      params.require(:question).permit(:title,:name,:content,:progress)
    end
    
    # アクセス権設定（before_action）

    # 管理者のみ許可 => destroy
    def permit_admin
      if user_signed_in? && current_user.admin? 
      else
        blocking_access()
      end
    end
    
    # ログインユーザのみ許可
    # ※authenticate_userではログイン画面にリダイレクトされるため、個別メソッド定義
    def permit_login_user
      if user_signed_in? == false
        blocking_access()
      end
    end
    
    # 回答ステータスの更新=>自身が作成した質問のみ許可
    def permit_update
      @question = Question.find(params[:id])
      if (user_signed_in? && current_user.id == @question.user_id) == false
        blocking_access
      end
    end
    
    # 質問の削除 => 自身が作成した質問のみ許可
    def permit_delete
      @question = Question.find(params[:id])
      if (user_signed_in? && current_user.id == @question.user_id) == false
        blocking_access_delete #リダイレクト先のリソース削除防止
      end
    end
    
    # アクセス禁止 アクション実行時 
    # flashメッセージを表示し、質問一覧へリダイレクト
    def blocking_access
      flash[:alert] = "あなたの権限では行えない操作です！"
      redirect_to questions_index_path
    end
    
    # アクセス禁止 アクション実行時(HTTP:DELETE)
    # flashメッセージを表示し、質問一覧へリダイレクト ※303リダイレクト
    def blocking_access_delete
      flash[:alert] = "あなたの権限では行えない操作です！"
      redirect_to questions_index_path, status: :see_other
    end

end
