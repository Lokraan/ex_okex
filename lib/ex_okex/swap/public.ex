defmodule ExOkex.Swap.Public do
  import ExOkex.Api.Public

  @prefix "/api/swap/v3"

  def instruments do
    get("#{@prefix}/instruments", %{})
  end

  def price_limit(instrument_id) do
    get("#{@prefix}/instruments/#{instrument_id}/price_limit")
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
  def orderbook(instrument_id, %{} = params) do
    get("#{@prefix}/#{instrument_id}/book", params)
  end
end
