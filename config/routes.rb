Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get 'questions/index'
  
  # rootをログイン画面に設定
  devise_scope :user do
    root "users/sessions#new"
  end
  
  # CRUD追加
  resources :questions do
    
    # 独自アクションの登録
    
    # コレクションルート（IDを持たない）
    collection do
      get 'my_question' #あなたの質問
      get 'resolve' #解決済み質問のみを表示する。
      get 'unanswered' #未解決の質問のみを表示する。
      get 'search' #質問の検索
    end
    
    # メンバールート（IDを持つ）
    member do
      post :'update_resolve' #質問を解決済みとする。
    end
    
    resources :answers
  end
  
  get 'sites/index'
  
end
