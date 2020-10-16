import ballerina/http;
import ballerina/log;

// Instance of http:Listener; This will listen to reqeusts on port 9090.
listener http:Listener httpListener = new(9090);

// For the time being, the orders will be managed using an in-memory map. 
map<json> ordersMap = {};

// RESTful service. The path of this service would be '/ordermgt'
@http:ServiceConfig { basePath: "/ordermgt"  }
service orderMgt on httpListener {

	@http:ResourceConfig {
		methods: ["GET"],
		path: "/orders"
	}
	resource function showOrders(http:Caller caller, http:Request req) {
		// Return the list of orders
		http:Response res = new;
		
		json? payload = ordersMap; 

		res.setJsonPayload(<@untainted> payload);
		
		// Send response
		var result = caller -> respond(res);
		if (result is error) {
			log:printError("Error sending response", err = result);
		}

	}

	// The resource that handles GET requests that mention a specific order using '/order/<orderID>'
	// The resource function will take the caller, request and the order ID of the request as parameters.
	@http:ResourceConfig {
		methods: ["GET"],
		path: "/order/{orderId}"
	}
	resource function findOrder(http:Caller caller, http:Request req, string orderId) {
		// Find the requested order, pull it out in JSON format.
		json? payload = ordersMap[orderId];
		http:Response res = new;
		
		// Checking whether the requested order exists
		if(payload == null) {
			payload = "Order: " + orderId + " cannot be found. ";	
		}

		// Setting the JSON payload as reseponse message
		res.setJsonPayload(<@untainted> payload);

		// Send response
		var result = caller -> respond(res);
		if (result is error) {
			log:printError("Error sending response", err = result);
		}
	}

	// The resource that handles POST requests that will use '/order' path to create a new order
	@http:ResourceConfig {
		methods: ["POST"],
		path: "/order"
	}
	resource function addOrder(http:Caller caller, http:Request req) {
		// Add the new order to ordersMap
		http:Response res = new;
		var orderReq = <@untainted> req.getJsonPayload();

		// New order is appended to the ordersMap
		if (orderReq is json) {
			//string orderId = orderReq.Order.ID.toString();
			var orderId = orderReq.Order.ID.toString();

			if (ordersMap[orderId] == null) {
				ordersMap[orderId] = orderReq;

				// Create response message
				json payload = { status: "Order Created", orderId: orderId};
				res.setJsonPayload(<@untainted> payload);

				// Set the status code to 201: Created
				res.statusCode = 201;

				// Set location header in the response message. This will contain the location of the newly created order.
				res.setHeader("Location", "http://127.0.0.1:9090/ordermgt/order/" + orderId);
			} else {
				json payload = { status: "Order not created. There is an existing order under that orderId.", orderId: orderId };
				res.setJsonPayload(<@untainted> payload);
			}
			// Send response to the client
			var result = caller -> respond(res);
			if (result is error) {
				log:printError("Error sending request", err = result);	
			}
		} else {
			res.statusCode = 400;
			res.setPayload("Invalid payload recieved");
			
			var result = caller -> respond(res);
			if (result is error) {
				log:printError("Error sending request", err = result);	
			}
		}
	}

	// The resource that handles PUT requests that will concentrate on a specific order to be updated using the path '/order/<orderID>'
	@http:ResourceConfig {
		methods: ["PUT"],
		path: "/order/{orderId}"
	}
	resource function updateOrder(http:Caller caller, http:Request req, string orderId) {
		// Update orders currently in the map
		http:Response res = new;
		var updatedOrder = <@untained> req.getJsonPayload();
		
		if (updatedOrder is json) {

			// The order is updated according to the request
			json existingOrder = ordersMap[orderId];

			if (existingOrder != null) {
				existingOrder = updatedOrder;
				ordersMap[orderId] = existingOrder;
			} else {
				existingOrder = "Order: " + orderId	+ " cannot be found. ";
			}

			//map<json> existingOrder = <map<json>> ordersMap[orderId];
			//map<json> order = <map<json>> existingOrder.get("Order");
			
			//if (order.keys().length() != 0) {
				//order["Name"] = <string> updatedOrder.Order.Name;
				//order["Description"] = <string> updatedOrder.Order.Description;
				//ordersMap[orderId] = existingOrder;
			//} else {
				//existingOrder = <json> "Order : " + orderId + " cannot be found.";	
			//}
			
			// The payload to be sent to the client.
			res.setJsonPayload(<@untained> existingOrder);

			// Send response to client
			var result = caller -> respond(res);
			if (result is error) {
				log:printError("Error sending response", err = result);	
			}
		} else {
			res.statusCode = 400;
			res.setPayload("Invalid payload recieved");
			var result = caller -> respond(res);
			if (result is error) {
				log:printError("Error sending response", err = result);	
			}
		}
	}

	// Resource that handles DELETE requests that will mention a specific order to be deleted using the path 'order/<orderID>'
	@http:ResourceConfig {
		methods: ["DELETE"],
		path: "/order/{orderId}"
	}
	resource function deleteOrder(http:Caller caller, http:Request req, string orderId) {
		// Delete orders currently in the map.
		http:Response res = new;
		// Remove tje order from map object.
		_ = ordersMap.remove(orderId);

		// Set payload to be sent to the client.
		json payload = "Order:" + orderId + " removed successfully. ";
		res.setJsonPayload(<@untainted> payload);

		// Send response to the client
		var result = caller -> respond(res);
		if (result is error) {
			log:printError("Error sending response", err = result);	
		}
	}
}
