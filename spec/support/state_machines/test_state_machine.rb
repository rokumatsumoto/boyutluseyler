class TestStateMachine < FiniteMachine::Definition
  initial :step1

  def self.steps
    %i[step1 step2 step3]
  end

  event :go_forward,
        steps[0] => steps[1],
        steps[1] => steps[2]

  event :go_back,
        steps[2] => steps[1],
        steps[1] => steps[0]
end
