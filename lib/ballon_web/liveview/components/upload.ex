defmodule BallonWeb.Liveview.Components.Upload do
  use BallonWeb, :live_component

  def update(assigns, socket) do
    socket =
      socket
      |> assign(assigns)
      |> assign(:uploads, %{files: []})
      |> allow_upload(:files, [])

    {:ok, socket}
  end
end
