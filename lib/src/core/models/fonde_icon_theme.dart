import 'package:flutter/material.dart';

/// Defines the set of icons used throughout Fonde UI components.
///
/// Similar to [FondeColorScheme], this class allows applications to swap
/// the icon set used by all components via the [activeIconThemeProvider].
class FondeIconTheme {
  const FondeIconTheme({
    // Navigation related
    required this.layers,
    required this.share2,
    required this.search,
    required this.bookmark,
    required this.database,
    required this.terminal,
    required this.settings,
    required this.keyboard,
    // App-specific navigation and function icons
    required this.stacks,
    required this.graphNavigation,
    required this.bookmarks,
    required this.entityEditor,
    required this.metadataEditor,
    required this.commandPalette,
    // Panel operations
    required this.panelLeft,
    required this.panelLeftClose,
    required this.panelRight,
    required this.panelRightClose,
    // View types
    required this.table,
    required this.listTree,
    required this.calendar,
    required this.timeline,
    // Actions
    required this.save,
    required this.rotateCcw,
    required this.plus,
    required this.x,
    required this.ellipsis,
    // Arrows and directions
    required this.arrowLeft,
    required this.arrowRight,
    required this.arrowLeftRight,
    required this.arrowUpDown,
    required this.chevronDown,
    required this.chevronRight,
    // Check and selection
    required this.check,
    // Entity and data
    required this.circle,
    required this.link,
    required this.tag,
    required this.stickyNote,
    // Filter and sort
    required this.listFilter,
    // Interaction
    required this.mousePointerClick,
    required this.gripVertical,
    required this.separatorVertical,
    // Import operations
    required this.importAdd,
    required this.importUpdate,
    required this.importReplace,
    // Entity editor related
    required this.info,
    required this.id,
    required this.properties,
    required this.connections,
    required this.display,
    // File and document
    required this.fileText,
    // List and display
    required this.list,
    // Settings and tools
    required this.settingsAdvanced,
    required this.download,
    required this.import,
    required this.appearance,
    required this.globe,
    required this.accessibility,
    required this.add,
    required this.close,
    required this.command,
    required this.play,
    required this.zoom,
    required this.fit,
    required this.roadmap,
    required this.animation,
    required this.error,
    required this.sun,
    required this.moon,
    // Material Icons (Flutter standard)
    required this.editNote,
    required this.barChart,
    required this.helpOutline,
    required this.moreVert,
    required this.clear,
    required this.folderOpen,
    required this.star,
    required this.starBorder,
    required this.pushPinOutlined,
    required this.edit,
    required this.copy,
    required this.uploadFile,
    required this.folder,
    required this.archiveOutlined,
    required this.deleteOutline,
  });

  // Navigation related
  final IconData layers;
  final IconData share2;
  final IconData search;
  final IconData bookmark;
  final IconData database;
  final IconData terminal;
  final IconData settings;
  final IconData keyboard;

  // App-specific navigation and function icons
  final IconData stacks;
  final IconData graphNavigation;
  final IconData bookmarks;
  final IconData entityEditor;
  final IconData metadataEditor;
  final IconData commandPalette;

  // Panel operations
  final IconData panelLeft;
  final IconData panelLeftClose;
  final IconData panelRight;
  final IconData panelRightClose;

  // View types
  final IconData table;
  final IconData listTree;
  final IconData calendar;
  final IconData timeline;

  // Actions
  final IconData save;
  final IconData rotateCcw;
  final IconData plus;
  final IconData x;
  final IconData ellipsis;

  // Arrows and directions
  final IconData arrowLeft;
  final IconData arrowRight;
  final IconData arrowLeftRight;
  final IconData arrowUpDown;
  final IconData chevronDown;
  final IconData chevronRight;

  // Check and selection
  final IconData check;

  // Entity and data
  final IconData circle;
  final IconData link;
  final IconData tag;
  final IconData stickyNote;

  // Filter and sort
  final IconData listFilter;

  // Interaction
  final IconData mousePointerClick;
  final IconData gripVertical;
  final IconData separatorVertical;

  // Import operations
  final IconData importAdd;
  final IconData importUpdate;
  final IconData importReplace;

  // Entity editor related
  final IconData info;
  final IconData id;
  final IconData properties;
  final IconData connections;
  final IconData display;

  // File and document
  final IconData fileText;

  // List and display
  final IconData list;

  // Settings and tools
  final IconData settingsAdvanced;
  final IconData download;
  final IconData import;
  final IconData appearance;
  final IconData globe;
  final IconData accessibility;
  final IconData add;
  final IconData close;
  final IconData command;
  final IconData play;
  final IconData zoom;
  final IconData fit;
  final IconData roadmap;
  final IconData animation;
  final IconData error;
  final IconData sun;
  final IconData moon;

  // Material Icons (Flutter standard)
  final IconData editNote;
  final IconData barChart;
  final IconData helpOutline;
  final IconData moreVert;
  final IconData clear;
  final IconData folderOpen;
  final IconData star;
  final IconData starBorder;
  final IconData pushPinOutlined;
  final IconData edit;
  final IconData copy;
  final IconData uploadFile;
  final IconData folder;
  final IconData archiveOutlined;
  final IconData deleteOutline;

  FondeIconTheme copyWith({
    IconData? layers,
    IconData? share2,
    IconData? search,
    IconData? bookmark,
    IconData? database,
    IconData? terminal,
    IconData? settings,
    IconData? keyboard,
    IconData? stacks,
    IconData? graphNavigation,
    IconData? bookmarks,
    IconData? entityEditor,
    IconData? metadataEditor,
    IconData? commandPalette,
    IconData? panelLeft,
    IconData? panelLeftClose,
    IconData? panelRight,
    IconData? panelRightClose,
    IconData? table,
    IconData? listTree,
    IconData? calendar,
    IconData? timeline,
    IconData? save,
    IconData? rotateCcw,
    IconData? plus,
    IconData? x,
    IconData? ellipsis,
    IconData? arrowLeft,
    IconData? arrowRight,
    IconData? arrowLeftRight,
    IconData? arrowUpDown,
    IconData? chevronDown,
    IconData? chevronRight,
    IconData? check,
    IconData? circle,
    IconData? link,
    IconData? tag,
    IconData? stickyNote,
    IconData? listFilter,
    IconData? mousePointerClick,
    IconData? gripVertical,
    IconData? separatorVertical,
    IconData? importAdd,
    IconData? importUpdate,
    IconData? importReplace,
    IconData? info,
    IconData? id,
    IconData? properties,
    IconData? connections,
    IconData? display,
    IconData? fileText,
    IconData? list,
    IconData? settingsAdvanced,
    IconData? download,
    IconData? import,
    IconData? appearance,
    IconData? globe,
    IconData? accessibility,
    IconData? add,
    IconData? close,
    IconData? command,
    IconData? play,
    IconData? zoom,
    IconData? fit,
    IconData? roadmap,
    IconData? animation,
    IconData? error,
    IconData? sun,
    IconData? moon,
    IconData? editNote,
    IconData? barChart,
    IconData? helpOutline,
    IconData? moreVert,
    IconData? clear,
    IconData? folderOpen,
    IconData? star,
    IconData? starBorder,
    IconData? pushPinOutlined,
    IconData? edit,
    IconData? copy,
    IconData? uploadFile,
    IconData? folder,
    IconData? archiveOutlined,
    IconData? deleteOutline,
  }) {
    return FondeIconTheme(
      layers: layers ?? this.layers,
      share2: share2 ?? this.share2,
      search: search ?? this.search,
      bookmark: bookmark ?? this.bookmark,
      database: database ?? this.database,
      terminal: terminal ?? this.terminal,
      settings: settings ?? this.settings,
      keyboard: keyboard ?? this.keyboard,
      stacks: stacks ?? this.stacks,
      graphNavigation: graphNavigation ?? this.graphNavigation,
      bookmarks: bookmarks ?? this.bookmarks,
      entityEditor: entityEditor ?? this.entityEditor,
      metadataEditor: metadataEditor ?? this.metadataEditor,
      commandPalette: commandPalette ?? this.commandPalette,
      panelLeft: panelLeft ?? this.panelLeft,
      panelLeftClose: panelLeftClose ?? this.panelLeftClose,
      panelRight: panelRight ?? this.panelRight,
      panelRightClose: panelRightClose ?? this.panelRightClose,
      table: table ?? this.table,
      listTree: listTree ?? this.listTree,
      calendar: calendar ?? this.calendar,
      timeline: timeline ?? this.timeline,
      save: save ?? this.save,
      rotateCcw: rotateCcw ?? this.rotateCcw,
      plus: plus ?? this.plus,
      x: x ?? this.x,
      ellipsis: ellipsis ?? this.ellipsis,
      arrowLeft: arrowLeft ?? this.arrowLeft,
      arrowRight: arrowRight ?? this.arrowRight,
      arrowLeftRight: arrowLeftRight ?? this.arrowLeftRight,
      arrowUpDown: arrowUpDown ?? this.arrowUpDown,
      chevronDown: chevronDown ?? this.chevronDown,
      chevronRight: chevronRight ?? this.chevronRight,
      check: check ?? this.check,
      circle: circle ?? this.circle,
      link: link ?? this.link,
      tag: tag ?? this.tag,
      stickyNote: stickyNote ?? this.stickyNote,
      listFilter: listFilter ?? this.listFilter,
      mousePointerClick: mousePointerClick ?? this.mousePointerClick,
      gripVertical: gripVertical ?? this.gripVertical,
      separatorVertical: separatorVertical ?? this.separatorVertical,
      importAdd: importAdd ?? this.importAdd,
      importUpdate: importUpdate ?? this.importUpdate,
      importReplace: importReplace ?? this.importReplace,
      info: info ?? this.info,
      id: id ?? this.id,
      properties: properties ?? this.properties,
      connections: connections ?? this.connections,
      display: display ?? this.display,
      fileText: fileText ?? this.fileText,
      list: list ?? this.list,
      settingsAdvanced: settingsAdvanced ?? this.settingsAdvanced,
      download: download ?? this.download,
      import: import ?? this.import,
      appearance: appearance ?? this.appearance,
      globe: globe ?? this.globe,
      accessibility: accessibility ?? this.accessibility,
      add: add ?? this.add,
      close: close ?? this.close,
      command: command ?? this.command,
      play: play ?? this.play,
      zoom: zoom ?? this.zoom,
      fit: fit ?? this.fit,
      roadmap: roadmap ?? this.roadmap,
      animation: animation ?? this.animation,
      error: error ?? this.error,
      sun: sun ?? this.sun,
      moon: moon ?? this.moon,
      editNote: editNote ?? this.editNote,
      barChart: barChart ?? this.barChart,
      helpOutline: helpOutline ?? this.helpOutline,
      moreVert: moreVert ?? this.moreVert,
      clear: clear ?? this.clear,
      folderOpen: folderOpen ?? this.folderOpen,
      star: star ?? this.star,
      starBorder: starBorder ?? this.starBorder,
      pushPinOutlined: pushPinOutlined ?? this.pushPinOutlined,
      edit: edit ?? this.edit,
      copy: copy ?? this.copy,
      uploadFile: uploadFile ?? this.uploadFile,
      folder: folder ?? this.folder,
      archiveOutlined: archiveOutlined ?? this.archiveOutlined,
      deleteOutline: deleteOutline ?? this.deleteOutline,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! FondeIconTheme) return false;
    return layers == other.layers &&
        share2 == other.share2 &&
        search == other.search &&
        bookmark == other.bookmark &&
        database == other.database &&
        terminal == other.terminal &&
        settings == other.settings &&
        keyboard == other.keyboard &&
        stacks == other.stacks &&
        graphNavigation == other.graphNavigation &&
        bookmarks == other.bookmarks &&
        entityEditor == other.entityEditor &&
        metadataEditor == other.metadataEditor &&
        commandPalette == other.commandPalette &&
        panelLeft == other.panelLeft &&
        panelLeftClose == other.panelLeftClose &&
        panelRight == other.panelRight &&
        panelRightClose == other.panelRightClose &&
        table == other.table &&
        listTree == other.listTree &&
        calendar == other.calendar &&
        timeline == other.timeline &&
        save == other.save &&
        rotateCcw == other.rotateCcw &&
        plus == other.plus &&
        x == other.x &&
        ellipsis == other.ellipsis &&
        arrowLeft == other.arrowLeft &&
        arrowRight == other.arrowRight &&
        arrowLeftRight == other.arrowLeftRight &&
        arrowUpDown == other.arrowUpDown &&
        chevronDown == other.chevronDown &&
        chevronRight == other.chevronRight &&
        check == other.check &&
        circle == other.circle &&
        link == other.link &&
        tag == other.tag &&
        stickyNote == other.stickyNote &&
        listFilter == other.listFilter &&
        mousePointerClick == other.mousePointerClick &&
        gripVertical == other.gripVertical &&
        separatorVertical == other.separatorVertical &&
        importAdd == other.importAdd &&
        importUpdate == other.importUpdate &&
        importReplace == other.importReplace &&
        info == other.info &&
        id == other.id &&
        properties == other.properties &&
        connections == other.connections &&
        display == other.display &&
        fileText == other.fileText &&
        list == other.list &&
        settingsAdvanced == other.settingsAdvanced &&
        download == other.download &&
        import == other.import &&
        appearance == other.appearance &&
        globe == other.globe &&
        accessibility == other.accessibility &&
        add == other.add &&
        close == other.close &&
        command == other.command &&
        play == other.play &&
        zoom == other.zoom &&
        fit == other.fit &&
        roadmap == other.roadmap &&
        animation == other.animation &&
        error == other.error &&
        sun == other.sun &&
        moon == other.moon &&
        editNote == other.editNote &&
        barChart == other.barChart &&
        helpOutline == other.helpOutline &&
        moreVert == other.moreVert &&
        clear == other.clear &&
        folderOpen == other.folderOpen &&
        star == other.star &&
        starBorder == other.starBorder &&
        pushPinOutlined == other.pushPinOutlined &&
        edit == other.edit &&
        copy == other.copy &&
        uploadFile == other.uploadFile &&
        folder == other.folder &&
        archiveOutlined == other.archiveOutlined &&
        deleteOutline == other.deleteOutline;
  }

  @override
  int get hashCode => Object.hashAll([
    layers,
    share2,
    search,
    bookmark,
    database,
    terminal,
    settings,
    keyboard,
    stacks,
    graphNavigation,
    bookmarks,
    entityEditor,
    metadataEditor,
    commandPalette,
    panelLeft,
    panelLeftClose,
    panelRight,
    panelRightClose,
    table,
    listTree,
    calendar,
    timeline,
    save,
    rotateCcw,
    plus,
    x,
    ellipsis,
    arrowLeft,
    arrowRight,
    arrowLeftRight,
    arrowUpDown,
    chevronDown,
    chevronRight,
    check,
    circle,
    link,
    tag,
    stickyNote,
    listFilter,
    mousePointerClick,
    gripVertical,
    separatorVertical,
    importAdd,
    importUpdate,
    importReplace,
    info,
    id,
    properties,
    connections,
    display,
    fileText,
    list,
    settingsAdvanced,
    download,
    import,
    appearance,
    globe,
    accessibility,
    add,
    close,
    command,
    play,
    zoom,
    fit,
    roadmap,
    animation,
    error,
    sun,
    moon,
    editNote,
    barChart,
    helpOutline,
    moreVert,
    clear,
    folderOpen,
    star,
    starBorder,
    pushPinOutlined,
    edit,
    copy,
    uploadFile,
    folder,
    archiveOutlined,
    deleteOutline,
  ]);
}
