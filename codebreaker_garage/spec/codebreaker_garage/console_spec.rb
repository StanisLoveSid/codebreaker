require 'spec_helper'

module Codebreaker_garage
  RSpec.describe Console do

    describe "#start" do
      before do
        subject.instance_variable_set(:@user_tries_to_guess, '1234')
        allow(subject.instance_variable_get(:@game)).to receive(:has_attempts?).and_return(true)
      end

      it "says that game has been started" do
        allow(subject).to receive(:gets).and_return('exit')
        expect { subject.start }.to output(/New game has been started/).to_stdout
      end

      it "print mark answer" do
        allow(subject).to receive(:gets).and_return('1234')
        allow(subject.instance_variable_get(:@game)).to receive(:correct_input).and_return('----')
        expect { subject.start }.to output(/----/).to_stdout
      end

      it 'should print warning massege if wrong input' do
        allow(subject).to receive(:gets).and_return('11111')
        expect { subject.start }.to output(/You can use only 4 numbers from 1 to 6./).to_stdout
      end

    end

    describe "#correct_input" do
      it "gives result" do
        subject.instance_variable_set(:@user_tries_to_guess, '1234')
        allow(subject.instance_variable_get(:@game)).to receive(:give_result).and_return("----")
        expect {subject.correct_input}.to output(/----/).to_stdout
      end
    end

    context '#replay' do
      before do
        allow(subject).to receive(:start)
        allow(subject).to receive(:gets).and_return('y')
      end

      it 'ask about play again' do
        expect { subject.send(:replay) }.to output(/Do you want to play again?/).to_stdout
      end

      it "create new game" do
        allow(subject).to receive(:puts)
        expect(Game).to receive(:new)
        subject.send(:replay)
      end

      it "call #start method" do
        allow(subject).to receive(:puts)
        expect(subject).to receive(:start)
        subject.send(:replay)
      end
    end

    context '#want_to_save' do
      before do
        allow(subject).to receive(:save_data)
        allow(subject).to receive(:gets).and_return('y')
      end

      it 'ask about play again' do
        expect { subject.send(:want_to_save) }.to output(/Do you want to save the game result?/).to_stdout
      end

      it "call #save_dara method" do
        allow(subject).to receive(:puts)
        expect(subject).to receive(:save_data)
        subject.send(:want_to_save)
      end
    end

    context '#save_data' do

      after { File.delete('./statistics.yaml') }

      it 'statistics.yaml should exist' do
        allow(subject).to receive(:puts)
        subject.send(:save_data)
        allow(subject).to receive(:gets).and_return('name')
        expect(File.exist?('./statistics.yaml')).to eq true
        expect(subject).to receive(:replay)
      end
    end

  end
end
