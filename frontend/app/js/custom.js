$('#git-tree-content').on('select_node.jstree', function(e, data){
  var gitNode = data.node.data;
  var sha = gitNode.sha;
  if(gitNode.type === 'file'){
  $.ajax({
    type: 'get',
    dataType: 'json',
    url: '/submissions/'+key+'/blobs/'+sha,
    success : function(response) {
      $('#git-code').html(response.data);
    },
    error: function(xhr, status, error) {
      var err = JSON.parse(xhr.responseText);
      alert('Error '+ err.error_msg);
    }
  });
}
}).jstree({ 'core' : {
  'data' : treeContent 
   } 
});