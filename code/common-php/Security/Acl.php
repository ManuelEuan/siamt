<?php
namespace App\Library\Security;

// use App\Library\Db\Db;

class Acl
{
	// TokenWrapper
	private $token;

    public function __construct($token)
    {
        $this->token = $token;
	}

	public function allow($module, $permission)
	{
		$permissions = $this->getModulePermissions($module);
		
		$allowed = in_array($permission, $permissions, true);

		return $allowed;
	}
	
	public function dwhAllow($permission)
	{
		return $this->allow(ModulePermission::DWH, $permission);
	}
	
	public function getModulePermissions($module)
	{
		$allPermissions = $this->token->getPermissions();
		
		$permissions = $allPermissions[$module] ?? [];

		return $permissions;
	}
	
	public function getDwhPermissions()
	{
		return $this->getModulePermissions(ModulePermission::DWH);
	}
}