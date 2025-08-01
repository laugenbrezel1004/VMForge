#[macro_use] extern crate rocket;
use rocket::serde::{json::Json, Deserialize, Serialize};
use rocket::http::Status;
use rocket::request::{self, Request, FromRequest};
use rocket::outcome::Outcome;

#[derive(Debug, Deserialize, Serialize)]
#[serde(crate = "rocket::serde")]
pub struct Data {
    hostname: String,
    cpu_cores: String,
    //email: String,
    //company_name: Option<String>,
    //phone: Option<String>,
    //message_body: Option<String>,
}

#[post("/api/buildvm", format = "json", data = "<form>")]
fn buildvm(form: Json<Data>) -> Status {
    println!("Received contact form: {:?}", form);
    // Hier könnten Sie die Daten in einer Datenbank speichern
    Status::Ok
}

#[launch]
fn rocket() -> _ {
    rocket::build()
        .mount("/", routes![buildvm])
}