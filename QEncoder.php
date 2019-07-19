<?php

class QEncoder extends PluginAbstract
{
	/**
	* @var string Name of plugin
	*/
	public $name = 'QEncoder';

	/**
	* @var string Description of plugin
	*/
	public $description = 'Add encoding processes to a queue on upload. Based on work by Wes Wright.';

	/**
	* @var string Name of plugin author
	*/
	public $author = 'Justin Henry';

	/**
	* @var string URL to plugin's website
	*/
	public $url = 'https://uvm.edu/~jhenry/';

	/**
	* @var string Current version of plugin
	*/
	public $version = '0.0.1';
	
	/**
	* Attaches plugin methods to hooks in code base
	*/
	public function load() {
		Plugin::attachFilter( 'upload_info.encoder.command' , array( __CLASS__ , 'q_encoder' ) );
	}

	/**
	* Prepend queueing command to original encoding command. 
	* 
 	*/
	public static function q_encoder($command) {
        $config = Registry::get('config'); 

        $command = str_replace('nohup', '', $command);

        $q_pipe = DOC_ROOT . '/cc-content/plugins/QEncoder/bin/q_pipe.pl';
		$q_command = $q_pipe . ' ' . $command; 

        if ($config->debugConversion) {
            App::log(CONVERSION_LOG, "\n\n// Queued converter command: " . $q_command);
        }

        return $q_command;
    }
}
