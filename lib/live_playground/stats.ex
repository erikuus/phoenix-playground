defmodule LivePlayground.Stats do
  @moduledoc """
  Server statistics module for monitoring system performance.
  
  This module provides functions to fetch current server statistics
  including active connections, requests per second, and response times.
  The data simulates realistic server monitoring with occasional spikes
  and performance variations.
  """

  @doc """
  Returns the current number of active connections to the server.
  
  Simulates realistic connection counts with occasional traffic spikes
  that might occur during peak hours or special events.
  """
  def active_connections do
    case Enum.random(1..100) do
      n when n <= 85 -> Enum.random(50..200)    # Normal traffic (85%)
      n when n <= 95 -> Enum.random(200..500)   # High traffic (10%)
      _ -> Enum.random(500..1000)                # Traffic spike (5%)
    end
  end

  @doc """
  Returns the current requests per second being processed by the server.
  
  Simulates realistic request rates with variations based on server load
  and traffic patterns.
  """
  def requests_per_second do
    case Enum.random(1..100) do
      n when n <= 70 -> Enum.random(10..50)     # Normal load (70%)
      n when n <= 90 -> Enum.random(50..100)    # Medium load (20%)
      _ -> Enum.random(100..200)                 # High load (10%)
    end
  end

  @doc """
  Returns the current average response time in milliseconds.
  
  Simulates realistic response times that inversely correlate with server
  performance - higher during traffic spikes, lower during normal operation.
  """
  def response_time_ms do
    case Enum.random(1..100) do
      n when n <= 80 -> Enum.random(50..150)    # Good performance (80%)
      n when n <= 95 -> Enum.random(150..300)   # Degraded performance (15%)
      _ -> Enum.random(300..500)                 # Poor performance (5%)
    end
  end
end
