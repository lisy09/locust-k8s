from locust import HttpUser, task, between

class HelloWorldUser(HttpUser):
    wait_time = between(1,2)

    @task(weight=1)
    def hello_world(self):
        self.client.get("/")