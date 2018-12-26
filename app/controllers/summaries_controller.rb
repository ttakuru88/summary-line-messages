class SummariesController < ApplicationController
  def new
    @summary = Summary.new
  end

  def create
    error('ファイルを選択してください') and return if params[:line_messages].blank?

    Summary.transaction do
      @summary = Summary.create!(name: params[:line_messages].original_filename)
      @summary.import_from!(params[:line_messages], pickup_words: pickup_words)
    end

    redirect_to summary_path(id: @summary.uuid)
  end

  def show
    @summary = Summary.find_by!(uuid: params[:id])
  end

  private

  def error(error_message)
    @summary ||= Summary.new
    flash.now[:alert] = error_message
    render :new
  end

  def pickup_words
    [params[:word1], params[:word2], params[:word3]].map(&:presence).compact
  end
end
