# Private Events

Private Events is a Rails application that allows users to create and manage private events, send and respond to invitations, and receive notifications about event activities.

## Features

- **User Authentication:** Sign up, log in, log out, and account management.
- **Event Management:** Create, edit, and delete events.
- **Invitations:** Send, accept and decline invitations to events.
- **Notifications:** Receive notifications for sent and responded invitations.
- **Attendance Tracking:** Track users attending the events.

## Getting Started

### Prerequisites

- Ruby 3.2.2
- Rails 7.1.3.2
- SQLite

### Installation

1. Clone the repository:

    ```sh
    git clone https://github.com/khanrazee/private-events.git
    cd private-events
    ```

2. Install dependencies:

    ```sh
    bundle install
    ```

3. Set up the database:

    ```sh
    rails db:create
    rails db:migrate
    ```

4. Start the server:

    ```sh
    rails server
    ```

5. Visit [http://localhost:3000](http://localhost:3000) in your browser.

## Usage

### Creating an Event

1. Sign up or log in to your account.
2. Navigate to the 'Create Event' page.
3. Fill out the event form with a title, description, date, location, and image.
4. Click 'Save' to create the event.

### Sending Invitations

1. View the event details page.
2. Click 'Invite People' to send an invitation.
3. Select the user to invite and submit the form.

### Responding to Invitations

1. Navigate to the 'Invitations' page.
2. Choose to accept, decline, or maybe for each invitation.
3. The event creator will be notified of your response.

### Viewing Notifications

1. Navigate to the 'Notifications' page.
2. All notifications will be marked as read when you visit this page.
3. View notifications about invitations and responses.

## Models

### User

- `has_many :created_events, foreign_key: :creator_id, class_name: 'Event', dependent: :destroy`
- `has_many :event_attendances, foreign_key: :attendee_id, dependent: :destroy`
- `has_many :attended_events, through: :event_attendances, source: :attended_event`
- `has_many :invitations, foreign_key: :invitee_id, dependent: :destroy`
- `has_many :invited_events, through: :invitations, source: :event`
- `has_many :notifications, foreign_key: :recipient_id, dependent: :destroy`
- `has_many :sent_notifications, class_name: 'Notification', foreign_key: :actor_id, dependent: :destroy`

### Event

- `belongs_to :creator, class_name: 'User'`
- `has_many :event_attendances, foreign_key: :attended_event_id, dependent: :destroy`
- `has_many :attendees, through: :event_attendances, source: :attendee`
- `has_many :invitations, dependent: :destroy, foreign_key: :event_id, class_name: 'Invitation'`
- `has_one_attached :image`

- `scope :past, -> { where('date < ?', Time.now) }`
- `scope :upcoming, -> { where('date >= ?', Time.now) }`

- `validates :title, :description, :date, :location, presence: true`
- `mount_uploader :image, ImageUploader`

### Invitation

- `belongs_to :event`
- `belongs_to :invitee, class_name: 'User'`

- `enum status: { pending: 0, accepted: 1, declined: 2, maybe: 3 }`

### Notification

- `belongs_to :recipient, class_name: 'User'`
- `belongs_to :actor, class_name: 'User'`
- `belongs_to :notifiable, polymorphic: true`

- `scope :unread, -> { where(read_at: nil) }`
