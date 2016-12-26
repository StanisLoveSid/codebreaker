require 'spec_helper'

module Codebreaker_garage
  RSpec.describe Console do
    subject(:console) {Console.new}
    let(:game) { console.instance_variable_get(:@game) }
    describe "#start" do

      before do
        allow(subject).to receive(:want_to_save)
        allow(game).to receive(:has_attempts?).and_return(false)
      end

      it "says that game has been started" do
        allow(subject).to receive(:gets).and_return('exit')
        expect { subject.start }.to output(/New game has been started/).to_stdout
      end

      it 'prints hint' do
        allow(subject).to receive(:gets).and_return('hint')
        allow(game).to receive(:receive_hint).and_return("hint")
        expect { subject.start }.to output(/hint/).to_stdout
      end

      it "prints warning" do
        allow(subject).to receive(:gets).and_return('1234e')
        expect { subject.send(:start)}.to output(/You can use only 4 numbers from 1 to 6./).to_stdout
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
        allow(subject).to receive(:gets).and_return('y')
        allow(subject).to receive(:save_data)
        allow(subject).to receive(:replay)
      end

      it 'ask about saving the game result' do
        expect { subject.send(:want_to_save) }.to output(/Do you want to save the game result?/).to_stdout
      end

      it "call #save_dara method" do
        allow(subject).to receive(:puts)
        expect(subject).to receive(:save_data)
        subject.send(:want_to_save)
      end
    end

    context '#save_data' do

      it 'statistics.yml should exist' do
        allow(subject).to receive(:puts)
        allow(game).to receive(:statistics)
        allow(subject).to receive(:gets).and_return('name')
        allow(subject).to receive(:save_data)
        expect(File.exist?('statistics.yml')).to eq true
      end
    end

  end
end
