defmodule LiveViewTodosWeb.TodoLive do
	use LiveViewTodosWeb, :live_view
	alias LiveViewTodos.Todos

	def mount(_params, _session, socket) do
		Todos.subscribe()
		{:ok, fetch(socket)}
	end

	def handle_event("add", %{"todo" => todo}, socket) do
		todo |> Todos.create_todo()
		{:noreply, socket}
	end

	def handle_event("delete", %{"id" => id}, socket) do
		todo = id |> Todos.get_todo!()

		todo |> Todos.delete_todo()
		{:noreply, socket}
	end

	def handle_event("toggle_done", %{"id" => id}, socket) do
		todo = id |> Todos.get_todo!()

		todo |> Todos.update_todo(%{done: !todo.done})
		{:noreply, socket}
	end

	def handle_info({Todos, [:todo | _], _}, socket) do
		{:noreply, fetch(socket)}	
	end

	defp fetch(socket) do
		assign(socket, todos: Todos.list_todos())
	end
end