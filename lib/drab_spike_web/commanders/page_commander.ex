defmodule DrabSpikeWeb.PageCommander do
  use Drab.Commander, modules: [Drab.Query]

  @moduledoc """
  Drab commander for PageController
  """

  @steps 6
  onload :page_loaded

  # Drab Callbacks

  def page_loaded(socket) do
    exec_js(socket, "$('[data-progress]').transition('fade', '2s')")
    exec_js(socket, "$('[data-start-button]').transition('jiggle')")
  end

  # Drab Events

  def start_process(socket, sender) do
    socket
      |> init_ui(sender)
      |> insert(cancel_button(socket, self()), prepend: "[data-cancel-area]")
      |> exec_js("$('[data-cancel-area]').transition('fly right in')")

    step(socket, @steps, 0)
  end

  def cancel_process(socket, sender) do
    token = sender["data"]["pid"]
    task = process_from_token(socket, token)

    if Process.alive?(task) do
      send(task, :cancel_processing)
    end

    reset_ui_on_cancel(socket)
  end

  # Functions

  defp init_ui(socket, _sender) do
    socket
      |> animate_on_start
      |> insert(class: "disabled", into: "[data-start-button]")
      |> insert(class: "active", into: "[data-loader]")
  end

  defp reset_ui_on_success(socket) do
    :timer.sleep(1000)
    socket
      |> animate_on_complete
      |> clean_up

    reset_ui(socket)
  end

  defp reset_ui_on_cancel(socket) do
    socket
      |> insert(class: "error", into: "[data-progress]")
      |> animate_on_complete
      |> clean_up

    :timer.sleep(1000)
    reset_ui(socket)
  end

  defp animate_on_start(socket) do
    exec_js(socket, "$('[data-start-area]').transition('horizontal flip out')")
    exec_js(socket, "$('[data-statistics-area]').transition('scale in')")
    socket
  end

  defp animate_on_complete(socket) do
    exec_js(socket, "$('[data-cancel-area]').transition('hide')")
    exec_js(socket, "$('[data-statistics-area]').transition('fly left out')")
    socket
  end

  defp clean_up(socket) do
    delete(socket, "[drab-click=cancel_process]")
    execute(socket, :show, on: "[drab-click=start_process]")
  end

  defp reset_ui(socket) do
    socket
      |> delete(class: "disabled", from: "[data-start-button]")
      |> update(:html, set: "", on: "[data-progress-label]")
      |> delete(class: "active", from: "[data-loader]")
      |> update(css: "width", set: "0", on: "[data-progress-bar]")
      |> update(:text, set: "#{@steps}", on: "[data-waiting-value]")
      |> update(:text, set: "0", on: "[data-running-value]")
      |> update(:text, set: "0", on: "[data-done-value]")
      |> delete(class: "success", from: "[data-progress]")
      |> delete(class: "error", from: "[data-progress]")

    exec_js(socket, "$('[data-start-area]').transition('horizontal flip in')")
    socket
  end

  defp cancel_button(socket, pid) do
    """
    <button drab-click="cancel_process" data-cancel-button="true"
            data-pid="#{token_from_process(socket, pid)}"
            class="ui red tiny basic button">
      Cancel
    </button>
    """
  end

  defp step(socket, last_step, last_step) do
    # last step, when number of steps == current step
    socket
      |> update_bar(last_step, last_step)
      |> update_stats(last_step, last_step)
      |> insert(class: "success", into: "[data-progress]")
      |> update(css: "width", set: "100%", on: "[data-progress-bar]")
      |> reset_ui_on_success
  end

  defp step(socket, steps, i) do
    receive do
      :cancel_processing ->
        clean_up(socket)
    after 0 ->
      1..3
        |> Task.async_stream(&do_some_work/1)
        |> Enum.to_list

      socket
        |> update(:text, set: "0", on: "[data-waiting-value]")
        |> update_bar(steps, i)
        |> update_stats(steps, i)
        |> step(steps, i + 1)
    end
  end

  defp do_some_work(_i) do
    :timer.sleep(:rand.uniform(750))
  end

  defp update_bar(socket, steps, i) do
    socket
      |> update(
          css: "width",
          set: progress_bar_width(i, steps),
          on: "[data-progress-bar]")
      |> update(
          :html,
          set: progress_bar_text(i, steps),
          on: "[data-progress-label]")
  end

  defp update_stats(socket, steps, i) do
    socket
      |> update(
          :text,
          set: "#{steps - i}",
          on: "[data-running-value]")
      |> update(
          :text,
          set: "#{i}",
          on: "[data-done-value]")
  end

  defp progress_bar_width(i, steps) do
    "#{i * 100 / steps}%"
  end

  defp progress_bar_text(i, steps) do
    "#{Float.round(i * 100 / steps, 1)}%"
  end

  defp token_from_process(socket, process) do
    Drab.tokenize(socket, process)
  end

  defp process_from_token(socket, token) do
    Drab.detokenize(socket, token)
  end
end
