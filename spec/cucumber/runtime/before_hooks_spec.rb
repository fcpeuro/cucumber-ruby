require 'spec_helper'
require 'cucumber/messages/id_generator'
require 'cucumber/runtime/before_hooks'

module Cucumber
  class Runtime
    describe BeforeHooks do
      let(:subject) { BeforeHooks.new(id_generator, hooks, scenario, event_bus) }
      let(:id_generator) { Cucumber::Messages::IdGenerator::Incrementing.new }
      let(:hooks) { [] }
      let(:scenario) { double }
      let(:event_bus) { double }

      describe '#apply_to' do
        let(:test_case) { double }
        let(:hooks) { [hook] }
        let(:hook) { double }

        before do
          allow(test_case).to receive(:with_steps)
          allow(test_case).to receive(:test_steps).and_return([])
          allow(hook).to receive(:location)
          allow(event_bus).to receive(:hook_test_step_created)
        end

        it 'fires a :hook_test_step_created event for each created step' do
          subject.apply_to(test_case)

          expect(event_bus).to have_received(:hook_test_step_created)
        end

        context 'when multiple hooks are applied' do
          let(:hooks) { [hook, hook, hook] }

          it 'fires a :hook_test_step_created event for each step' do
            subject.apply_to(test_case)
            expect(event_bus).to have_received(:hook_test_step_created).exactly(3).times
          end
        end
      end
    end
  end
end
