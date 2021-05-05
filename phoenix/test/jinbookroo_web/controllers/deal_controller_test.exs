defmodule JinbookrooWeb.DealControllerTest do
  use JinbookrooWeb.ConnCase

  alias Jinbookroo.Books
  alias Jinbookroo.Books.Deal

  @create_attrs %{
    made_on: ~D[2010-04-17],
    entries: [
      %{description: "Some entry", side: :debit, subject: "Entry", person_id: "", ammount: 20},
      %{description: "Some entry", side: :credit, subject: "Entry", ammount: 20}
    ]
  }
  @update_attrs %{
    made_on: ~D[2011-05-18],
    entries: [
      %{description: "Some entry", side: :debit, subject: "Entry", person_id: "", ammount: 10},
      %{description: "Some entry", side: :credit, subject: "Entry", person_id: "", ammount: 20},
      %{description: "Some entry", side: :credit, subject: "Entry", person_id: "", ammount: 30}
    ]
  }
  @invalid_attrs %{made_on: nil}

  def fixture(:deal) do
    {:ok, deal} = Books.create_deal_with_entries(@create_attrs)
    deal
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all deals", %{conn: conn} do
      conn = get(conn, Routes.deal_path(conn, :index))
      assert json_response(conn, 200) == []
    end
  end

  describe "create deal" do
    test "renders deal when data is valid", %{conn: conn} do
      conn = post(conn, Routes.deal_path(conn, :create), @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)

      conn = get(conn, Routes.deal_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "made_on" => "2010-04-17",
               "entries" => [%{"id" => _}, %{"id" => _}]
             } = json_response(conn, 200)

    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.deal_path(conn, :create), @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update deal" do
    setup [:create_deal]

    test "renders deal when data is valid", %{conn: conn, deal: %Deal{id: id} = deal} do
      conn = put(conn, Routes.deal_path(conn, :update, deal), @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)

      conn = get(conn, Routes.deal_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "made_on" => "2011-05-18",
               "entries" => [%{"id" => _}, %{"id" => _}, %{"id" => _}]
             } = json_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, deal: deal} do
      conn = put(conn, Routes.deal_path(conn, :update, deal), @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "creates entries", %{conn: conn, deal: %Deal{id: id} = deal} do
      entries_attrs = deal.entries |> Enum.map(&(%{id: &1.id, side: &1.side, subject: &1.subject, ammount: &1.ammount}))
      update_attrs = Map.merge(@update_attrs, %{entries: entries_attrs ++ [%{side: :credit, subject: "Created", ammount: 100}]})
      conn = put(conn, Routes.deal_path(conn, :update, deal), update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)

      conn = get(conn, Routes.deal_path(conn, :show, id))
      assert %{
               "entries" => [
                 _, _,
                 %{"id" => _, "side" => "credit", "subject" => "Created", "ammount" => 100}
               ]
             } = json_response(conn, 200)
    end

    test "updates entries", %{conn: conn, deal: %Deal{id: id} = deal} do
      entries_attrs = deal.entries |> Enum.map(&(%{id: &1.id, side: :credit, subject: "Updated", ammount: 100}))
      update_attrs = Map.merge(@update_attrs, %{entries: entries_attrs})
      conn = put(conn, Routes.deal_path(conn, :update, deal), update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)

      conn = get(conn, Routes.deal_path(conn, :show, id))
      assert %{
               "entries" => [
                 %{"id" => _, "side" => "credit", "subject" => "Updated", "ammount" => 100},
                 %{"id" => _, "side" => "credit", "subject" => "Updated", "ammount" => 100}
               ]
             } = json_response(conn, 200)
    end

    test "destroys entries", %{conn: conn, deal: %Deal{id: id} = deal} do
      update_attrs = Map.merge(@update_attrs, %{entries: []})
      conn = put(conn, Routes.deal_path(conn, :update, deal), update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)

      conn = get(conn, Routes.deal_path(conn, :show, id))
      assert %{
               "entries" => []
             } = json_response(conn, 200)
    end
  end

  describe "delete deal" do
    setup [:create_deal]

    test "deletes chosen deal", %{conn: conn, deal: deal} do
      conn = delete(conn, Routes.deal_path(conn, :delete, deal))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.deal_path(conn, :show, deal))
      end
    end
  end

  defp create_deal(_) do
    deal = fixture(:deal)
    %{deal: deal}
  end
end
