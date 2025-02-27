package cup.example;

public class TreeNodePrinter 
{
	private TreeNode node = null;
	
    public TreeNodePrinter(TreeNode node)
    {
    	this.node=node;
    }
    
    public void Print() 
    {
    	PrintLevel(node, 0);
    }     

    private void PrintLevel(TreeNode currentNode, int level)
    {
    	if(currentNode == null) 
    	{
    		return;    		
    	}
                   
    	for (int i= 0; i < level; i++) 
    	{
    		System.out.print("  ");    		
    	}
    	System.out.println(currentNode.getNodeInfo());
        
    	TreeNode[] children = currentNode.getChildren();
        for(int i = 0; i < children.length; ++i)
        {
        	PrintLevel(children[i], level+1);
        }
    }
}