vcl 4.1;

backend default {
    .host = "127.0.0.1";
    .port = "8080";
}

sub vcl_backend_response {
	set beresp.ttl = 1w;

	if (bereq.url ~ "/cover") {
		set beresp.ttl = 100w;
	}

	if (bereq.url ~ "^/static/") {
		set beresp.ttl = 100w;
	}
}
