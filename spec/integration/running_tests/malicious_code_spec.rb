require 'spec_helper'

describe RemoteSandboxForTesting, :integration => true do
  describe "when the student's code attempts to delete tests" do
    it "should not leave tests unrun" do
      setup = SubmissionTestSetup.new(:exercise_name => 'malicious/TestDeleter')
      submission = setup.submission
      
      setup.make_zip
      RemoteSandboxForTesting.run_submission(submission)
      
      submission.test_case_runs.size.should == 2
      submission.test_case_runs.should_not be_all(&:successful)
      submission.test_case_runs.should be_any(&:successful)
      
      case_names = submission.test_case_runs.map(&:test_case_name)
      case_names.sort.should == ['ATest test1', 'BTest test2']
      case_messages = submission.test_case_runs.map(&:message)
      case_messages.should include("Failed to run test.")
    end
  end
end
