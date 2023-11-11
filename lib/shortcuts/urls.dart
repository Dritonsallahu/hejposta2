// general urls
// var protocol = "http://";
var protocol = "https://";
// var port = "3000";
// var host = "192.168.1.61:3000";
var host = "hejposta.herokuapp.com";
var imgUrl = "$protocol$host";
var fullUrl = "$protocol$host/api/v1/mobile/";
var authUrl = '${fullUrl}authenticate';
var registerUrl = '${fullUrl}register';
var qytetetUrl = '${fullUrl}qytetet';
var orderHistoryUrl = '$fullUrl/order-history';
var fcmTokenUrl = '${fullUrl}fcm-token';
var commentsUrl = '${fullUrl}comments';
var rulesUrl = '${fullUrl}rules';

// $2a$08$CLeYzRZpN3tD/x.ViiOuce9YEW.OEXv2WU8tguEECklXcw6MLbq2q
// $2a$08$sY8ohX9YFcwmMWdkQOsbX.0YPGpxVxew1.PS7e1481bwyF4Ptr93G FAIK POSTIERI
// $2a$08$GU1nj7AYhALojOlpyJN7u.FvWOLNUkQ8ByYyGgFhcCHKRknLP6FUi  Thanadev@1

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
var ngarkoPerDergeseUrl = '${fullUrl}postman/load';

var expencesUrl = '${fullUrl}postman/expences';
var expencesWithImageUrl = '${fullUrl}postman/expences-image';
var zonesUrl = '${fullUrl}postman/zones';
var deleteZoneUrl = '${fullUrl}postman/zone';

var financesUrl = '${fullUrl}postman/finances';
var statisticsUrl = '${fullUrl}postman/statistics';
var postmanProfileUrl = '${fullUrl}postman/profile';
var removePostmanAccountUrl = '${fullUrl}postman/remove-account';

var equalizationUrl = '${fullUrl}postman/equalizations';
var equalizedUrl = '${fullUrl}postman/orders-for-equalizations';
var performEqualizaiton = '${fullUrl}postman/equalize-client';

// client urls
var ordersUrl = '${fullUrl}client/orders';
var newOrderUrl = '${fullUrl}client/new-order';
var editOrderUrl = '${fullUrl}client/edit-order';
var deleteOrderUrl = '${fullUrl}client/delete-order';
var offersUrl = '${fullUrl}client/offers';
var unitsUrl = '${fullUrl}client/units';
var productsUrl = '${fullUrl}client/products';
var productsNoImageUrl = '${fullUrl}client/products-no-image';
var buyersUrl = '${fullUrl}client/buyers';
var clientProfileUrl = '${fullUrl}client/profile';
var financeProfileUrl = '${fullUrl}client/finances';
var statisticsProfileUrl = '${fullUrl}client/statistics';
var challengesProfileUrl = '${fullUrl}client/challenges';
var challengeProfileUrl = '${fullUrl}client/challenge';
var messagesProfileUrl = '${fullUrl}client/messages';
var onlineRequestsUrl = '${fullUrl}client/online-requests';
