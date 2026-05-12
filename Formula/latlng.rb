class Latlng < Formula
  desc "Geospatial object server and command-line tools"
  homepage "https://github.com/tobilg/latlng"
  url "https://github.com/tobilg/latlng/releases/download/v0.1.2/latlng-macos-arm64.tar.gz"
  sha256 "a8966843a800283f4d5a693d3030c43b113c1d1737909d178ca8750ee17afa76"
  version "0.1.2"
  license "MIT"

  depends_on :macos
  depends_on arch: :arm64

  def default_config
    <<~TOML
      listen_addr = "127.0.0.1:7421"
      capnp_enabled = false
      capnp_listen_addr = "127.0.0.1:7422"
      server_id = "latlng-homebrew-local"
      webhook_queue_path = "#{var}/latlng/webhook-queue.sqlite"
      log_destination = "file"
      log_file_path = "#{var}/log/latlng/latlng-server.log"

      [storage]
      type = "aof"
      path = "#{var}/latlng/appendonly.aof"
    TOML
  end

  def install
    bin.install "latlng-server"
    bin.install "latlng-cli"

    (etc/"latlng").mkpath
    (var/"latlng").mkpath
    (var/"log/latlng").mkpath

    config = etc/"latlng/latlng.toml"
    config.write default_config unless config.exist?
  end

  service do
    run [opt_bin/"latlng-server", "--config", etc/"latlng/latlng.toml"]
    keep_alive true
    working_dir var/"latlng"
    log_path var/"log/latlng/latlng-server.log"
    error_log_path var/"log/latlng/latlng-server.log"
  end

  def caveats
    <<~EOS
      Default service config:
        #{etc}/latlng/latlng.toml

      Default data directory:
        #{var}/latlng

      Default log file:
        #{var}/log/latlng/latlng-server.log

      The service listens on 127.0.0.1:7421 and uses AOF persistence by default.

      Start latlng as a background service:
        brew services start latlng

      Run manually:
        latlng-server --config #{etc}/latlng/latlng.toml
    EOS
  end

  test do
    assert_match "latlng-server #{version}", shell_output("#{bin}/latlng-server --version")
    assert_match "latlng-cli", shell_output("#{bin}/latlng-cli --help 2>&1")

    (testpath/"latlng.toml").write <<~TOML
      listen_addr = "127.0.0.1:7421"
      webhook_queue_path = "#{testpath}/webhook-queue.sqlite"

      [storage]
      type = "aof"
      path = "#{testpath}/appendonly.aof"
    TOML

    assert_match "\"ok\": true", shell_output("#{bin}/latlng-server --config #{testpath}/latlng.toml --check-config")
  end
end
