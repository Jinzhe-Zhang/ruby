class ArticlesController < ApplicationController
    private
    def article_params
        params.require(:article).permit(:title, :text)
    end
    public
    def new#对应
        
    end
    def index
        @articles = Article.all
    end
    def show
        @article = Article.find(params[:id])
    end
    def create
        @article = Article.new(article_params)
        @article.save
        redirect_to @article
    end
end
