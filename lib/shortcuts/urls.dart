// general urls
var protocol = "http://";
// var port = "3000";
var host = "192.168.1.44:3000";
var imgUrl = "$protocol$host";
var fullUrl = "$protocol$host/api/v1/mobile/";
var authUrl = '${fullUrl}authenticate';
var registerUrl = '${fullUrl}register';
var qytetetUrl = '${fullUrl}qytetet';
var orderHistoryUrl = '$fullUrl/order-history';

// postman urls
var pOrdersUrl = '${fullUrl}postman/orders';
var pOnDeliveringOrdersUrl = '${fullUrl}postman/delivering-orders';
var pOnEqualizeOrdersUrl = '${fullUrl}postman/equalize-orders';
var pranoPorosineUrl = '${fullUrl}postman/accept-order';
var dorezoNeDepoPorosineUrl = '${fullUrl}postman/accept-order-in_warehouse';
var refuzoPorosineUrl = '${fullUrl}postman/unaccept-order';
var dergoTeKlientiPorosineUrl = '${fullUrl}postman/recieved-order';
var refuzoNgaKlientiPorosineUrl = '${fullUrl}postman/reject-order';
var riktheNgaKlientiPorosineUrl = '${fullUrl}postman/return-order';


var expencesUrl = '${fullUrl}postman/expences';
var zonesUrl = '${fullUrl}postman/zones';

var financesUrl = '${fullUrl}postman/finances';
var statisticsUrl = '${fullUrl}postman/statistics';
var postmanProfileUrl = '${fullUrl}postman/profile';

var equalizationUrl = '${fullUrl}postman/equalizations';
var equalizedUrl = '${fullUrl}postman/orders-for-equalizations';
var performEqualizaiton = '${fullUrl}postman/equalize-client';

// client urls
var ordersUrl = '${fullUrl}client/orders';
var newOrderUrl = '${fullUrl}client/new-order';
var offersUrl = '${fullUrl}client/offers';
var unitsUrl = '${fullUrl}client/units';
var productsUrl = '${fullUrl}client/products';
var buyersUrl = '${fullUrl}client/buyers';
var clientProfileUrl = '${fullUrl}client/profile';
var financeProfileUrl = '${fullUrl}client/finances';
var statisticsProfileUrl = '${fullUrl}client/statistics';
var challengesProfileUrl = '${fullUrl}client/challenges';
var challengeProfileUrl = '${fullUrl}client/challenge';
