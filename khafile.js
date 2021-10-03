// Auto-generated
let project = new Project('chinese_puzzle_01_1_0_0');

project.addSources('Sources');
project.addLibrary("C:/dev/Armory3D/ArmorySDK2109a/ArmorySDK/armory");
project.addLibrary("C:/dev/Armory3D/ArmorySDK2109a/ArmorySDK/iron");
project.addParameter('armory.trait.internal.DebugConsole');
project.addParameter("--macro keep('armory.trait.internal.DebugConsole')");
project.addParameter('armory.trait.internal.Bridge');
project.addParameter("--macro keep('armory.trait.internal.Bridge')");
project.addParameter('armory.trait.internal.UniformsManager');
project.addParameter("--macro keep('armory.trait.internal.UniformsManager')");
project.addShaders("build_chinese_puzzle_01/compiled/Shaders/*.glsl", { noembed: false});
project.addShaders("build_chinese_puzzle_01/compiled/Hlsl/*.glsl", { noprocessing: true, noembed: false });
project.addAssets("build_chinese_puzzle_01/compiled/Assets/**", { notinlist: true });
project.addAssets("build_chinese_puzzle_01/compiled/Shaders/*.arm", { notinlist: true });
project.addAssets("C:/dev/Armory3D/ArmorySDK2109a/ArmorySDK/armory/Assets/brdf.png", { notinlist: true });
project.addAssets("C:/dev/Armory3D/ArmorySDK2109a/ArmorySDK/armory/Assets/smaa_area.png", { notinlist: true });
project.addAssets("C:/dev/Armory3D/ArmorySDK2109a/ArmorySDK/armory/Assets/smaa_search.png", { notinlist: true });
project.addShaders("C:/dev/Armory3D/ArmorySDK2109a/ArmorySDK/armory/Shaders/debug_draw/**");
project.addLibrary("C:/dev/Armory3D/ArmorySDK2109a/ArmorySDK/lib/zui");
project.addAssets("C:/dev/Armory3D/ArmorySDK2109a/ArmorySDK/armory/Assets/font_default.ttf", { notinlist: false });
project.addDefine('arm_deferred');
project.addDefine('arm_csm');
project.addDefine('rp_hdr');
project.addDefine('rp_renderer=Deferred');
project.addDefine('rp_shadowmap');
project.addDefine('rp_shadowmap_cascade=1024');
project.addDefine('rp_shadowmap_cube=512');
project.addDefine('rp_background=World');
project.addDefine('rp_render_to_texture');
project.addDefine('rp_compositornodes');
project.addDefine('rp_antialiasing=SMAA');
project.addDefine('rp_supersampling=1');
project.addDefine('rp_ssgi=SSAO');
project.addDefine('rp_translucency');
project.addDefine('js-es=6');
project.addDefine('arm_assert_level=Warning');
project.addDefine('arm_noembed');
project.addDefine('arm_soundcompress');
project.addDefine('arm_audio');
project.addDefine('arm_debug');
project.addDefine('arm_ui');
project.addDefine('arm_skin');
project.addDefine('arm_particles');
project.addDefine('armory');


resolve(project);
