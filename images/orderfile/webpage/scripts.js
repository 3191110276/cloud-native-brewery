$(document).ready(function() {
    $( ".product  > button" ).click(function(event) {
        product = $(this).parent().children()[2].name
        quantity = $(this).parent().children()[2].value
        if(quantity == '') {
            alert('Value undefined')
        } else {
            $.ajax({
                type: "POST",
                url: "/api/order",
                data: {
                    product: product,
                    quantity: quantity
                },
                dataType: "json"
            })
            .done(function( data ) {
                console.log( data );
            });
        }
    });
});