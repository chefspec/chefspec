require File.join(File.dirname(__FILE__), *%w{.. spec_helper})

class Chef
  describe ExpectException do
    let(:m1){ 'message' }
    let(:m2){ 'message2' }
    let(:r){ 'return object' }
    let(:block){ Proc.new{|mess, exp| r} }
    let(:cm){ :chef_message }
    let(:e){ ErrorStub.new(m1) }
    let(:e2){ ErrorStub.new(m1) }
    let(:e3){ ErrorStub.new(m2) }
    let(:result){ ExpectException.expected?(cm, e)}

    after(:each) do
      ExpectException.clear
    end

    it 'expects nothing if nothing registered' do
      expect(result).to be_false
    end

    it 'expects an error if the matching class and message have been registered' do
      ExpectException.expect(ErrorStub, m1)
      expect(result).to be_true
    end

    it 'does not expect an error that does not match with a different class' do
      ExpectException.expect(StandardError, m1)
      expect(result).to be_false
    end

    it 'does not expect and error that has a different message' do
      ExpectException.expect(ErrorStub, m1[0..3])
      expect(result).to be_false
    end

    it 'allows a block to be registered' do
      ExpectException.expect_block(&block)
    end

    it 'passes in the chef message and exception to the block' do
      ExpectException.expect_block(&block)
      block.should_receive(:call).with(cm, e)
      result
    end

    it 'returns the return value from a registered block' do
      ExpectException.expect_block(&block)
      expect(result).to eq(r)
    end

    it 'clears expectations' do
      ExpectException.expect(ErrorStub, m1)
      ExpectException.clear
      expect(result).to be_false
    end

    it 'accepts additonal parameters' do
      ExpectException.expect(ErrorStub, m1)
      expect(ExpectException.expected?(cm, e3, :arg1)).to be_false
      expect(ExpectException.expected?(cm, e, 4, '5', {6 => 7})).to be_true
    end
  end
end
