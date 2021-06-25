RSpec.describe Securenv::Client do
  let(:fake_ssm_client){ double Aws::SSM::Client }
  let(:app){ 'testapp' }
  let(:stage){ 'testing' }
  let(:client){ Securenv::Client.new(app: app, stage: stage) }

  before do
    allow(Aws::SSM::Client).to receive(:new).and_return(fake_ssm_client)
  end

  describe "set" do
    let(:fake_put_parameter_response){ double Aws::SSM::Types::PutParameterResult, version: 1 }
    it "will make a put_parameter call to SSM" do
      expect(fake_ssm_client).to receive(:put_parameter).and_return(fake_put_parameter_response)
      parameter = client.set(variable: 'foo', value: 'bar')
      expect(parameter.version).to eq(1)
    end
  end

  describe "get" do
    let(:fake_aws_parameter){double Aws::SSM::Types::Parameter, version: 1, value: 'wat'}
    let(:fake_get_parameter_response){ double Aws::SSM::Types::GetParameterResult, parameter: fake_aws_parameter }
    it "will make a get_parameter call to SSM" do
      expect(fake_ssm_client).to receive(:get_parameter).and_return(fake_get_parameter_response)
      parameter = client.get(variable: 'foo')
      expect(parameter.value).to eq('wat')
    end
    it "will raise Securenv::ParameterNotFoundError if the parameter isn't found" do
      expect(fake_ssm_client).to receive(:get_parameter).and_raise(Aws::SSM::Errors::ParameterNotFound.new('arg1', 'arg2'))
      expect{ client.get(variable: 'foo') }.to raise_error(Securenv::ParameterNotFoundError)
    end
  end

  describe "unset" do
    let(:fake_delete_parameter_response){ double Aws::SSM::Types::DeleteParameterResult }
    it "will make a delete_parameter call to SSM" do
      expect(fake_ssm_client).to receive(:delete_parameter).and_return(fake_delete_parameter_response)
      parameter = client.unset(variable: 'foo')
      expect(parameter.var_name).to eq('foo')
    end
    it "will raise Securenv::ParameterNotFoundError if the parameter isn't found" do
      expect(fake_ssm_client).to receive(:delete_parameter).and_raise(Aws::SSM::Errors::ParameterNotFound.new('arg1', 'arg2'))
      expect{ client.unset(variable: 'foo') }.to raise_error(Securenv::ParameterNotFoundError)
    end
  end

  describe "list" do
    let(:fake_aws_parameter){double Aws::SSM::Types::Parameter, version: 1, value: 'wat', name: '/testapp/testing/FOO'}
    let(:fake_get_parameters_response){ double Aws::SSM::Types::GetParametersByPathResult, parameters: [fake_aws_parameter] }
    it "will make a get_parameters_by_path call to SSM" do
      expect(fake_ssm_client).to receive(:get_parameters_by_path).and_return(fake_get_parameters_response)
      parameters = client.list
      parameter = parameters.first
      expect(parameter.value).to eq('wat')
    end
  end

  describe 'populate_env' do
    let(:fake_aws_parameter){double Aws::SSM::Types::Parameter, version: 1, value: 'wat', name: '/testapp/testing/SECURENV_TEST_VAR'}
    let(:fake_get_parameters_response){ double Aws::SSM::Types::GetParametersByPathResult, parameters: [fake_aws_parameter] }
    it "sets some ENV variables" do
      expect(ENV['SECURENV_TEST_VAR']).to be_nil
      expect(fake_ssm_client).to receive(:get_parameters_by_path).and_return(fake_get_parameters_response)
      client.populate_env
      expect(ENV['SECURENV_TEST_VAR']).to eq('wat')
    end
  end
end
