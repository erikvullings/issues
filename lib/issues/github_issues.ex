defmodule Issues.GithubIssues do
  @user_agent [ {"User-agent", "Elixir erik.vullings@gmail.com"}]

  # use a module attribute to fetch the value at compile time
  @github_url Application.get_env(:issues, :github_url)

  def fetch(user, project) do
    IO.puts "Fetching"
    issues_url(user, project)
    |> HTTPoison.get(@user_agent)
    |> handle_response
  end

  def issues_url(user, project) do
    "#{@github_url}/repos/#{user}/#{project}/issues"
  end

  def handle_response({:ok, %HTTPoison.Response{body: body, status_code: 200}}) do
    IO.puts "Handling response"
    { :ok, :jsx.decode(body) }
  end
  def handle_response({:error, %HTTPoison.Error{reason: reason}}), do: { :error, :jsx.decode(reason) }

end
