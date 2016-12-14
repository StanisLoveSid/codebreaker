require 'spec_helper'

module Codebreaker_garage
  RSpec.describe Console do
    context '#start' do
      before do
        allow(subject.instance_variable_get(:@game)).to receive(:any_attempts?).and_return(false)
      end

      describe 'printing messages' do
        it 'says that new game has been started' do
          allow(subject).to receive(:gets).and_return('exit')
          expect { subject.start }.to output(/New game has been started./).to_stdout
        end

        it "shows hint if user asks" do
          allow(subject).to receive(:gets).and_return('hint')
          allow(subject.instance_variable_get(:@game)).to receive(:receive_hint).and_return('hint')
          expect { subject.start }.to output(/123456/).to_stdout
        end

        it 'prints marked result' do
          allow(subject).to receive(:gets).and_return('1111')
          allow(subject.instance_variable_get(:@game)).to receive(:guesser).and_return('----')
          expect { subject.start }.to output(/----/).to_stdout
        end

        it 'in case of wrong symbol, prints what user has to type' do
          allow(subject).to receive(:gets).and_return('eeee')
          expect { subject.start }.to output(/You should type a guess of four numbers from 1 to 6./).to_stdout
        end
      end
    end

    context '#replay' do
      before do
        allow(subject).to receive(:start)
        allow(subject).to receive(:gets).and_return('y')
      end

      it 'asks about play again' do
        expect { subject.send(:replay) }.to output(/Do you want to play again?/).to_stdout
      end

      it "starts new game" do
        allow(subject).to receive(:puts)
        expect(Game).to receive(:new)
        subject.send(:replay)
      end

      it "calls #start method" do
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

      it "calls #save_data" do
        subject.send(:want_to_save)
        expect { subject.send(:save_data) }.to output(/Do you want to save the game result?/).to_stdout
        expect(subject).to receive(:save_data)
      end
    end

    context '#save_data' do
      after { File.delete('./statistics.yaml') }

      it 'statistics.yaml must exist' do
        expect { subject.send(:save_data) }.to output(/Enter your name/).to_stdout
        allow(subject).to receive(:gets).and_return('name')
        expect(File.exist?('./statistics.yaml')).to eq(true)
      end
    end
  end
end
