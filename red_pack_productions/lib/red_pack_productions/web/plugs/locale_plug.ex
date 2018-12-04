defmodule RedPackProductionsWeb.Locale do
  import Plug.Conn

  def init(_) do
  end

  def call(conn, _) do
    case conn.params["locale"] || get_session(conn, :locale) do
      nil ->
        conn |> put_session(:locale, "nl")
      locale  ->
        Gettext.put_locale(RedPackProductionsWeb.Gettext, locale)
        conn |> put_session(:locale, locale)
    end
  end
end
