class ArticlesController < ApplicationController
  # By doing this we can run the set_article before these 4 methods/actions executed.
  before_action :set_article, only:[:show, :edit, :update, :destroy]

  def show
  end

  def index
    @articles = Article.all
  end

  def new
    @article = Article.new
  end

  def edit
    # get the current article object to fill the edit article form. in the haml we can just put @article and rails is smart enough to look for required attr for us.
  end

  def update
    if @article.update(article_params_whitelist)
      flash[:notice] = "Article updated successfully"
      redirect_to @article
    else
      render 'edit'
    end
  end

  #Rails is smart enough to get all the corresponding article attributes with params[:article], but first we need to whitelist the accepting attributes
  def create
    @article = Article.new(article_params_whitelist)
    # when we are trying to save articles with invalid title/descriptions, the validation we created in article model will prevent the invalid articles from saving to the
    # database, and the app is now redirecting to the index page. We need to somehow remind the user that the article is invalid and therefore not saving to the database.
    if @article.save
      flash[:notice] = "Article created successfully."
      #After creating and saving new article to the database, we can configure what to do after the creation, in this case we redirect to the show page of the created article
      #redirect_to article_path(@article) #Rails will find out the required attr in @article
      # we can even just do this!
      redirect_to @article
    else
      # We can simply show all the error messages to notice users
      render 'new'
    end #end if
  end

  def destroy
    @article.destroy
    redirect_to articles_path
  end

  private
  # any instance method after private keyword will become a private method
  def set_article
    @article = Article.find(params[:id])
  end

  def article_params_whitelist
    params.require(:article).permit(:title, :description)
  end
end