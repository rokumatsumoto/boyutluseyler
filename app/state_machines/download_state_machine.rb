
class DownloadStateMachine < FiniteMachine::Definition
  initial :not_ready

  event :go_forward, {
    :not_ready => :requested,
    :requested => :ready,
    :file_updated => :requested,
  }
  event :go_back, {
    :ready => :file_updated,
    :requested => :file_updated
  }
end
