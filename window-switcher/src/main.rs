use iced::widget::{column, text, text_input};
use iced::{Element, Length, Task, Theme};

pub fn main() -> iced::Result {
    iced::application("Hello, World! - Iced", Hello::update, Hello::view)
        .run_with(|| (Hello::new(), Task::none()))
}

struct Hello {
    addressee: String,
}

impl Hello {
    fn new() -> Self {
        Self {
            addressee: String::from("World"),
        }
    }

    fn update(&mut self, message: Message) -> Task<Message> {
        match message {
            Message::TextBoxChange(new_text) => {
                self.addressee = new_text;
                Task::none()
            }
        }
    }

    fn view(&self) -> Element<Message> {
        let greeting = text(format!("Hello, {}.", self.addressee));
        let input = text_input("Type a name...", &self.addressee)
            .on_input(Message::TextBoxChange)
            .width(Length::Fill);

        column![greeting, input]
            .padding(20)
            .spacing(10)
            .width(Length::Fill)
            .into()
    }
}

#[derive(Debug, Clone)]
enum Message {
    TextBoxChange(String),
}
