defmodule RedPackProductionsWeb.BlogController do
  use RedPackProductionsWeb, :controller

  # ==================================
  #               Index
  # ==================================
  def index(conn, _params) do

    blogPosts = CachedContentful.Api.customEntrySearch(
      "ordered_blogposts",
      %{"content_type": "blogPost", "order": "sys.createdAt"}, 
      true,
      get_session(conn, :locale)
    )

    blogPosts = Enum.map(blogPosts, fn(post) ->

      thumbnail = if post["fields"]["photos"] != nil do
        photo = CachedContentful.Api.getAssetById(List.first(post["fields"]["photos"])["sys"]["id"])
        "#{photo["fields"]["file"]["url"]}?w=250"
      else
        nil
      end

      %{
          title: post["fields"]["title"],
          slug: post["fields"]["slug"],
          thumbnail: thumbnail,
        }
    end)

    conn
      |> assign(:og_description, "Low budget/HIGH QUALITY Audio-Recording studio.")
      |> assign(:title, "Red Pack Productions - Blog")
      |> render("index.html", blogPosts: blogPosts) 
  end

  # ==================================
  #               Show
  # ==================================
  def show(conn, %{"slug" => slug}) do

    blogposts = CachedContentful.Api.getEntriesByType("blogPost", get_session(conn, :locale));

    # Get details for one blog post
    blogPost = Enum.map(blogposts, fn(post) ->
      if slug == post["fields"]["slug"] do

        photo = if post["fields"]["photos"] != nil do
          photo = CachedContentful.Api.getAssetById(List.first(post["fields"]["photos"])["sys"]["id"])
          photo["fields"]["file"]["url"]
        else
          "/images/rp_logo.png"
        end

        htmlDetails = Earmark.as_html(post["fields"]["content"])

        %{
          title: post["fields"]["title"],
          subtitle: post["fields"]["subtitle"],
          content: elem(htmlDetails, 1),
          slug: post["fields"]["slug"],
          photo: photo,
        }
      end
    end)
      |> Enum.filter(fn(x) -> x != nil end)
      |> Enum.fetch!(0)

    conn
      |> assign(:og_description, "#{blogPost.title}")
      |> assign(:title, "Red Pack Productions - #{blogPost.title}")
      |> render("show.html", blogPost: blogPost) 
  end

end