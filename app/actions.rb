helpers do
    def current_user
        User.find_by(id: session[:user_id])
    end
end

get '/' do
    @posts = Post.order(created_at: :desc)
    erb (:index)
end

get '/signup' do        #if a user navigates to the path "/signup",
    @user = User.new    # setup empty @user object
    erb(:signup)        #render "app/views/signup.erb"
end

post '/signup' do
    # grab user input values from params
    email         = params[:email]
    avatar_url    = params[:avatar_url]
    username      = params[:username]
    password      = params[:password]
    
    #instantiate and save a User
    @user = User.new({ email: email, avatar_url: avatar_url, username: username, password: password})
        
        #if user validations pass and user is saved   
        if @user.save
            redirect(to('/login'))
        else
            erb(:signup)
        end
end

get '/login' do     #when a get request comes into /login
    erb(:login)     #render correctly
end

post '/login' do
    username = params[:username]
    password = params[:password]
    
    user = User.find_by(username: username)
        
    if user && user.password == password
        session[:user_id] = user.id
        redirect(to('/'))
        else
        @error_message = "Login failed."
        erb(:login)
    end
end

get '/logout' do
    session[:user_id] = nil
    redirect(to('/'))
end

get '/posts/new' do
    @post = Post.new
    erb(:"posts/new")
end

post '/posts' do
    photo_url = params[:photo_url]
    
    #instantiate new Post
    @post = Post.new({ photo_url: photo_url, user_id: current_user.id })
    
    #if @post validates, save
    if @post.save
        redirect(to('/'))
    else
        erb(:"posts/new")
    end
end

get '/posts/:id' do
    @post = Post.find(params[:id])
    erb(:"posts/show")
end

post '/comments' do
    text = params[:text]
    post_id = params[:post_id]
    comment = Comment.new({ text: text, post_id: post_id, user_id: current_user.id})
    comment.save
    redirect(back)
end

post'likes' do
    post_id = params[:post_id]
    like = Like.new({ post_id: post_id, user_id: current_user.id })
    like.save
    redirect(back)
end

delete '/likes/:id' do
    like = Like.find(params[:id])
    like.destroy
    redirect(back)
end

get '/posts/new' do
    erb(:"posts/new")
end

post '/posts/' do
    params.to_s
end

post '/posts' do
    photo_url = params[:photo_url]
    #instantiate new Post
    @post = Post.new({ photo_url: photo_url, user_id: current_user.id })
    # if @post validates, save
    if @posts.save
        redirect(to('/'))
    else
        #if it doesn't validate, print error messages
        erb(:"posts/new")
    end
end

get'/posts/:id' do
    params[:id]
end

get'/post/:id' do
    @post = Post.friend(params[:id])    #find the post with the ID fro the URL
    erb(:"/posts/show")                 #print to the screen for now
end

