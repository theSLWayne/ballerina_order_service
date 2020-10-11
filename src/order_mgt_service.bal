import ballerina/http;

// Instance of http:Listener; This will listen to reqeusts on port 9090.
listener http:Listener httpListener = new(9090);

// For the time being, the orders will be managed using an in-memory map. 
map<json> ordersMap = {};

// RESTful service. The path of this service would be '/ordermgt'
@http:ServiceConfig { basePath: "/ordermgt"  }
service orderMgt on httpListener {

	// The resource that handles GET requests that mention a specific order using '/order/<orderID>'
	// The resource function will take the caller, request and the order ID of the request as parameters.
	@http:ResourceConfig {
		methods: ["GET"],
		path: "/order/{orderId}"
	}
	resource function findOrder(http:Caller caller, http:Request req, string orderId) {
		// Implementation of the function; How to handle a GET request.
	}

	// The resource that handles POST requests that will use '/order' path to create a new order
	@http:ResourceConfig {
		methods: ["POST"],
		path: "/order"
	}
	resource function addOrder(http:Caller caller, http:Request req) {
		// Implementation of the function; How to handle a POST request.	
	}

	// The resource that handles PUT requests that will concentrate on a specific order to be updated using the path '/order/<orderID>'
	@http:ResourceConfig {
		methods: ["PUT"],
		path: "/order/{orderId}"
	}
	resource function updateOrder(http:Caller caller, http:Request req, string orderId) {
		// Implementation of the function; How to handle a PUT request.	
	}

	// Resource that handles DELETE requests that will mention a specific order to be deleted using the path 'order/<orderID>'
	@http:ResourceConfig {
		methods: ["DELETE"],
		path: "/order/{orderId}"
	}
	resource function deleteOrder(http:Caller caller, http:Request req, string orderId) {
		// Implementation of the function; How to handle a DELETE request.	
	}
}
