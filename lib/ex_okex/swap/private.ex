defmodule ExOkex.Swap.Private do
  @moduledoc """
  Swap account client.

  [API docs](https://www.okex.com/docs/en/#swap-README)
  """

  import ExOkex.Api.Private

  @type params :: map
  @type config :: ExOkex.Config.t()
  @type response :: ExOkex.Api.response()

  @prefix "/api/swap/v3"

  @doc """
  Place a new order.

  ## Examples

  iex> ExOkex.Swap.create_order(%{
    instrument_id: "BTC-USD-180213",
    leverage: "10",
    type: "1",
    price: "432.11",
    size: "2",
    match_price: "0"
  })
  {:ok, %{"order_info" => [%{"error_code" => 0, "error_message" => "", "order_id" => "2653481276189696"}], "result" => true}}
  """
  @spec create_order(params, config | nil) :: response
  def create_order(params, config \\ nil) do
    post("#{@prefix}/order", params, config)
  end

  @doc """
  Place multiple orders for specific trading pairs (up to 4 trading pairs, maximum 4 orders each)

  https://www.okex.com/docs/en/#swap-swap---batch

  ## Examples

  iex> ExOkex.Swap.create_bulk_orders([
    %{"instrument_id":"BTC-USD-180213",
      "type":"1",
      "price":"432.11",
      "size":"2",
      "match_price":"0",
      "leverage":"10" },
    ])

    # TODO: Add response sample

  """
  @spec create_bulk_orders([params], config | nil) :: response
  def create_bulk_orders(params, config \\ nil) do
    post("#{@prefix}/orders", params, config)
  end

  defdelegate create_batch_orders(params, config \\ nil), to: __MODULE__, as: :create_bulk_orders

  @doc """
  Cancelling an unfilled order.

  https://www.okex.com/docs/en/#swap-swap---revocation

  ## Example

      iex> ExOkex.Swap.cancel_orders("BTC-USD-180309", [1600593327162368,1600593327162369])

      # TODO: Add response
  """
  def cancel_orders(instrument_id, order_ids \\ [], params \\ %{}, config \\ nil) do
    new_params = Map.merge(params, %{ids: order_ids})
    post("#{@prefix}/cancel_batch_orders/#{instrument_id}", new_params, config)
  end

  @doc """
  Get the swap account info of all token.

  https://www.okex.com/docs/en/#swap-singleness

  ## Examples

      iex(3)> ExOkex.Swap.list_accounts()

      # TODO: Add Response
  """
  def list_accounts(config \\ nil) do
    get("#{@prefix}/accounts", %{}, config)
  end

  @doc """
  Get the information of holding positions of a contract.

  https://www.okex.com/docs/en/#swap-hold_information

  ## Examples

      iex(3)> ExOkex.Swap.get_position("BTC-USD-190329")

  """
  def get_position(instrument_id, config \\ nil) do
    get("#{@prefix}/#{instrument_id}/position", %{}, config)
  end

  def get_positions(config \\ nil) do
    get("#{@prefix}/position", %{}, config)
  end

  def get_leverage(instrument_id, config \\ nil) do
    get("#{@prefix}/accounts/#{instrument_id}/settings", %{}, config)
  end

  @doc """
  Get the current orderbook for the specified future.

  Private and public implementation so that you can bypass rate limits.
  Need to bypass rate limits because websocket doesn't allow you to set the bucket size.

  https://www.okex.com/docs/en/#swap-swap---data

  ## Examples
    iex(1)> params = %{
      size: 200,
      depth: 1
    }
    %{
      size: 200,
      depth: 1
    }

    iex(2)> ExOkex.Futures.order_book("BTC-USD-SWAP", params)
  """
  def orderbook(instrument_id, %{} = params, config \\ nil) do
    get("#{@prefix}/instruments/#{instrument_id}/book", params, config)
  end
end
