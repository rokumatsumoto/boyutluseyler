module PageReload
  def init_reload_check
    Capybara.page.evaluate_script "window.not_reloaded = 'not reloaded';"
  end

  def not_reloaded?
    Capybara.page.evaluate_script('window.not_reloaded') == 'not reloaded'
  end

  def expect_page_to_not_reload
    init_reload_check
    yield
    sleep 0.01
    expect(not_reloaded?).to be_truthy, 'expected page to not reload, got page reload'
  end

  def expect_page_to_reload
    init_reload_check
    yield
    sleep 0.01
    expect(not_reloaded?).to be_falsy, 'expected page to reload, got page not reload'
  end
end
