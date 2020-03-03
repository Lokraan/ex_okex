defmodule ExOkex.Spot.Public do
  import ExOkex.Api.Public

  @prefix "/api/spot/v3"

  @moduledoc """
  Spot account client.
  """

  @doc """
  Get the current orderbook for the specified future.

  Private and public implementation so that you can bypass rate limits.
  Need to bypass rate limits because websocket doesn't allow you to set the bucket size.

  https://www.okex.com/docs/en/#spot-data

  ## Examples
    iex(1)> params = %{
      size: 400,
      depth: 1
    }
    %{
      size: 400,
      depth: 1
    }

    iex(2)> ExOkex.Futures.order_book("BTC-USD", params)
  """
  def orderbook(instrument_id, %{} = params) do
    get("#{@prefix}/instruments/#{instrument_id}/book", params)
  end
end
