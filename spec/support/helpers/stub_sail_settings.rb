module StubSailSettings
  def stub_sail_direct_upload_settings
    allow(Sail).to receive(:get).with('direct_upload_content_length_range_min').and_return(1)

    allow(Sail).to receive(:get).with('direct_upload_content_length_range_max').and_return(104_857_600)
  end
end
