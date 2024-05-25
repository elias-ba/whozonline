defmodule WhozonlineWeb.UserLive do
  alias Ecto.UUID
  use WhozonlineWeb, :live_view

  alias WhozonlineWeb.Presence

  def mount(_params, _session, socket) do
    if connected?(socket) do
      # Replace with actual user identification logic
      user_id = UUID.generate()
      topic = "user_live:presence"

      Presence.track(self(), topic, user_id, %{
        online_at: Timex.now() |> Timex.Format.DateTime.Formatters.Relative.format!("{relative}"),
        # Add more user info as needed
        user_info: %{id: user_id}
      })

      WhozonlineWeb.Endpoint.subscribe(topic)
    end

    {:ok, assign(socket, :users, %{})}
  end

  def handle_info(%{event: "presence_diff", payload: _diff}, socket) do
    users = Presence.list("user_live:presence")
    {:noreply, assign(socket, :users, users)}
  end

  def render(assigns) do
    ~H"""
    <div class="flow-root">
      <ul role="list" class="-mb-8">
        <%= for {user_id, %{metas: metas}} <- @users do %>
          <% meta = hd(metas) %>
          <li>
            <div class="relative pb-8">
              <span class="absolute left-4 top-4 -ml-px h-full w-0.5 bg-gray-200" aria-hidden="true">
              </span>
              <div class="relative flex space-x-3">
                <div>
                  <span class="h-8 w-8 rounded-full bg-gray-400 flex items-center justify-center ring-8 ring-white">
                    <svg
                      class="h-5 w-5 text-white"
                      viewBox="0 0 20 20"
                      fill="currentColor"
                      aria-hidden="true"
                    >
                      <path d="M10 8a3 3 0 100-6 3 3 0 000 6zM3.465 14.493a1.23 1.23 0 00.41 1.412A9.957 9.957 0 0010 18c2.31 0 4.438-.784 6.131-2.1.43-.333.604-.903.408-1.41a7.002 7.002 0 00-13.074.003z" />
                    </svg>
                  </span>
                </div>
                <div class="flex min-w-0 flex-1 justify-between space-x-4 pt-1.5">
                  <div>
                    <p class="text-sm text-gray-500">
                      <%= user_id %>
                    </p>
                  </div>
                  <div class="whitespace-nowrap text-right text-sm text-gray-500">
                    <time datetime="2020-09-20">
                      <%= meta.online_at %>
                    </time>
                  </div>
                </div>
              </div>
            </div>
          </li>
        <% end %>
      </ul>
    </div>
    """
  end
end
