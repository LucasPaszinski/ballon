defmodule BallonWeb.UploadLive do
  use BallonWeb, :live_view

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:uploaded_files, [])
      |> allow_upload(:avatar, accept: :any)

    {:ok, socket}
  end

  def handle_event("save", _params, socket) do
    IO.puts("save")
    IO.inspect(socket, label: :socket)
    uploaded_files =
      consume_uploaded_entries(socket, :avatar, fn %{path: path}, %{client_name: file_name} ->
        dest = Path.join("priv/static/uploads", "#{Path.basename(path)}_#{file_name}")
        File.cp!(path, dest)
        Routes.static_path(socket, "/uploads/#{Path.basename(dest)}_#{file_name}")
      end)

    {:noreply, update(socket, :uploaded_files, &(&1 ++ uploaded_files))}
  end

  def handle_event("validate", _params, socket) do
    IO.puts("validate")

    {:noreply, socket}
  end

  def handle_event("cancel-upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :avatar, ref)}
  end

  def handle_progress(:avatar, entry, socket) do
    IO.puts("progress")

    socket =
      if entry.done? do
        uploaded_file =
          consume_uploaded_entry(socket, entry, fn %{path: path} ->
            dest = Path.join("priv/static/uploads", Path.basename(path))
            File.cp!(path, dest)
            Routes.static_path(socket, "/uploads/#{Path.basename(dest)}")
          end)

        socket
        |> update(:uploaded_files, &(&1 ++ uploaded_file))
        |> put_flash(:info, "file #{uploaded_file.name} uploaded")
      else
        socket
      end

    {:noreply, socket}
  end
end
