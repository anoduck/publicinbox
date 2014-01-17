require 'spec_helper'

describe Message do
  describe 'automatically populating id & e-mail fields' do
    let(:message_attrs) do
      {
        :subject => 'Hey',
        :body => 'Long time no see'
      }
    end

    it 'populates sender e-mail, if possible' do
      dan = create_user('dan')
      message = dan.outgoing_messages.create!(message_attrs.merge({
        :recipient_email => 'joe@gmail.com'
      }))
      message.sender_email.should == 'dan@publicinbox.net'
    end

    it 'automatically populates recipient_id, if possible' do
      bob = create_user('bob')
      message = Message.create!(message_attrs.merge({
        :sender_email => 'sam@yahoo.com',
        :recipient_email => 'bob@publicinbox.net'
      }))
      message.recipient_id.should == bob.id
    end

    it 'automatically populates recipient_email, if possible' do
      dan = create_user('dan')
      bob = create_user('bob')
      message = dan.outgoing_messages.create!(message_attrs.merge({
        :recipient => bob
      }))
      message.recipient_email.should == 'bob@publicinbox.net'
    end
  end

  describe 'generating a unique token for every message' do
    it 'generates a token for all messages' do
      user = create_user('pat')
      message = create_message(user)
      message.unique_token.should_not be_nil
    end

    it 'ensures tokens are unique' do
      user = create_user('pat')

      first_message = create_message(user, :unique_token => 'foo')
      first_message.unique_token.should == 'foo'

      second_message = create_message(user, :unique_token => 'foo')
      second_message.unique_token.should_not be_nil
      second_message.unique_token.should_not == 'foo'
    end
  end

  describe 'trims surrounding whitespace...' do
    before :each do
      joe = create_user('joe')
      @message = joe.outgoing_messages.create!({
        :recipient_email => 'roy@hotmail.com',
        :subject => " \t\nHello again!\n\t ",
        :body => " \t\n How've you been? \n\t "
      })
    end

    it 'from the subject' do
      @message.subject.should == 'Hello again!'
    end

    it 'from the body' do
      @message.body.should == "How've you been?"
    end
  end

  describe 'validations' do
    context 'recipient_email' do
      before :each do
        @pete = create_user('pete')
      end

      def bad_email(email)
        should_fail do
          create_message(@pete, :recipient_email => email)
        end
      end

      def good_email(email)
        create_message(@pete, :recipient_email => email)
      end

      it 'must look reasonably like an actual e-mail address' do
        bad_email('foo')
        bad_email('foo.com')
        bad_email('foo@bar@baz')
        good_email('foo@example')
        good_email('foo@example.com')
        good_email('foo.bar@baz.example.com')
      end
    end
  end
end
