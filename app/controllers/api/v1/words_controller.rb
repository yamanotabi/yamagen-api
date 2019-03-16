module Api
    module V1
        class Api::V1::WordsController < ApplicationController
            before_action :set_word, only:[:show, :destroy]
            before_action :set_twitter_client, only:[:create]

            # GET /api/v1/word
            def index
                @words = Word.all
                render json: @words
            end

            # POST /api/v1/word
            def create
                # TODO: 
                # if image_url == nil => add image_url
                @word = Word.new(word_params)
                begin
                    if @word.save
                        render json: @word, status: :created
                    else
                        render json: @word.errors, status: :unprocessable_entity
                    end
                    @twitter.update!(@word.text)
                rescue => e
                    error = e
                    render json: error
                end
            end

            # GET /api/v1/word/:id
            def show
                render json: @word
            end

            # DELETE /api/v1/word/:id
            def destroy
                @word.destroy
                render status: 200, json: { status: 200, message: "Delete success #{@word.text}" }
            end

            def set_word
                @word = Word.find(params[:id])
            end
        
            private
            def word_params
                params.require(:word).permit(:access_token, :access_token_secret, :text, :user_name, :background_image_url, :user_image_url)
            end

            def set_twitter_client
                @twitter = Twitter::REST::Client.new do |config|
                  config.consumer_key        = ENV["TWITTER_API_KEY"]
                  config.consumer_secret     = ENV["TWITTER_API_SECRET_KEY"]
                  config.access_token        = params[:access_token]
                  config.access_token_secret = params[:access_token_secret]
                end
              end

        end
    end
end