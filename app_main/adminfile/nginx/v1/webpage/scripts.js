$(document).ready(function() {
    $( ".product  > button" ).click(function(event) {
        product = $(this).parent().children()[2].name
        quantity = $(this).parent().children()[2].value
        if(quantity == '') {
            alert('Value undefined')
        } else {
            $.post( "/api/produce", {
                product: product,
                quantity: quantity
            })
            .done(function( data ) {
                console.log( data );
            });
        }
    });
});