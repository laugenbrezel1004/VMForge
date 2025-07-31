#[macro_use] extern crate rocket;
use rocket::serde::{json::Json, Deserialize, Serialize};
use rocket::http::Status;
use rocket::request::{self, Request, FromRequest};
use rocket::outcome::Outcome;

#[derive(Debug, Deserialize, Serialize)]
#[serde(crate = "rocket::serde")]
pub struct ContactForm {
    first_name: String,
    last_name: String,
    email: String,
    company_name: Option<String>,
    phone: Option<String>,
    message_body: Option<String>,
}

#[post("/api/contact", format = "json", data = "<form>")]
fn submit_contact(form: Json<ContactForm>) -> Status {
    println!("Received contact form: {:?}", form);
    // Hier könnten Sie die Daten in einer Datenbank speichern
    Status::Ok
}

#[get("/api")]
fn index() -> &'static str {
    "Hello, world!"
}

#[get("/")]
fn hello() -> &'static str {
    "test"
}

#[get("/delay/<seconds>")]
async fn delay(seconds: u64) -> String {
    rocket::tokio::time::sleep(std::time::Duration::from_secs(seconds)).await;
    format!("Waited for {} seconds", seconds)
}

#[launch]
fn rocket() -> _ {
    rocket::build()
        .mount("/", routes![index, hello, delay, submit_contact])
}