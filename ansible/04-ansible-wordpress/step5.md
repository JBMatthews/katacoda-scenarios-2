## Nginx Forwarding Fixes

Pretty cool, huh? But, this isn’t what you want your users to see. You want them to see WordPress!

1\. So, you need to change the default nginx virtual host to receive requests and forward them. Run the following commands in the same directory as your playbook, to create a template file that you’ll use to configure nginx:

`mkdir -p templates/nginx && \
touch templates/nginx/default`{{execute}}

2\. You’ll also need to copy this file onto your remote machine using the template module. Let’s add a task to your playbook to do this:

<pre class="file" data-filename="playbook.yml"><blockquote>
    - name: Create nginx config
      template: src=templates/nginx/default dest=/etc/nginx/sites-available/default
</blockquote></pre>

3\. Edit `templates/nginx/default` and make sure that it contains the following content:

<pre class="file" data-filename="provisioning/templates/nginx/default"><blockquote>

server {
        server_name book.example.com;
        root /var/www/book.example.com;
        index index.php;
        location = /favicon.ico {
                log_not_found off;
                access_log off;
	}
        location = /robots.txt {
                allow all;
                log_not_found off;
                access_log off;
	}

	location ~ /\. {
                deny all;
	}
 	location ~* /(?:uploads|files)/.*\.php$ {
                deny all;
	}

	location / {
                try_files $uri $uri/ /index.php?$args;
	}
        rewrite /wp-admin$ $scheme://$host$uri/ permanent;

        location ~*
^.+\.(ogg|ogv|svg|svgz|eot|otf|woff|mp4|ttf|rss|atom|jpg|jpeg|gif|png|ico|zip|tgz|gz|rar|bz2|doc|xls|exe|ppt|tar|mid|midi|wav|bmp|rtf)$ {
               access_log off;
               log_not_found off;
	       expires max;
	}

	location ~ [^/]\.php(/|$) {
                fastcgi_split_path_info ^(.+?\.php)(/.*)$;
                if (!-f $document_root$fastcgi_script_name) {
			return 404;
		}
		include fastcgi_params;
		fastcgi_index index.php;
		fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
		fastcgi_pass php;
	}
}

</blockquote></pre>

>Note: The following configuration example is taken from the WordPress codex located at https://codex.wordpress.org/Nginx. This file is tricky! You may find that you'll need to alter it after copying and pasting it.
