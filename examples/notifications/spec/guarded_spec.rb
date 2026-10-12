require 'chefspec'

describe 'notifications::guarded' do
  platform 'ubuntu'

  let(:guarded)   { chef_run.file('/tmp/guarded') }
  let(:unguarded) { chef_run.file('/tmp/unguarded') }

  it 'does not run the guarded resource' do
    expect(chef_run).to_not delete_file('/tmp/guarded')
  end

  it 'does not notify from a resource a guard skipped' do
    expect(guarded).to_not notify('execute[reload]').to(:run).immediately
  end

  it 'still notifies from a resource that ran' do
    expect(unguarded).to notify('execute[reload]').to(:run).immediately
  end
end
